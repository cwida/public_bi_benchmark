#!/bin/env python

import os, sys
import subprocess
import json
import re

DATA_DIR="./"

def get_workbook_info():
	res = []

	for d in os.listdir(DATA_DIR):
		if not os.path.isdir(d):
			continue
		info = {"name": d, "tables": [], "path": os.path.join(DATA_DIR, d)}
		for t in os.listdir(info["path"]):
			if not t.endswith(".csv"):
				continue
			t_info = {
				"name": t[:-len('.csv')].strip('"'),
				"size_gb": float(os.path.getsize(os.path.join(info["path"], t))) / 1024 / 1024 / 1024
			}
			info["tables"].append(t_info)
		res.append(info)

	return res

def process_load_data(workbooks):
	# */load.*.out,err,re
	for wb in workbooks:
		for t in wb["tables"]:
			load_info = {}
			out_f = os.path.join(wb["path"], "load.{}.out".format(t["name"]))
			err_f = os.path.join(wb["path"], "load.{}.err".format(t["name"]))
			ret_f = os.path.join(wb["path"], "load.{}.ret".format(t["name"]))
			with open(ret_f, 'r') as f:
				load_info["ret"] = int(f.read())
			if load_info["ret"] != 0:
				out_reject_f = os.path.join(wb["path"], "load.{}-reject.out".format(t["name"]))
				err_reject_f = os.path.join(wb["path"], "load.{}-reject.err".format(t["name"]))
				ret_reject_f = os.path.join(wb["path"], "load.{}-reject.ret".format(t["name"]))
				with open(ret_reject_f, 'r') as f:
					load_info["ret_reject"] = int(f.read())
				# TODO: parse *-reject.out & get affeted rows & rejects
			t["load"] = load_info

def get_tables(query):
	from_regex = re.compile(r' from (.*?) ')

	m = from_regex.findall(query)
	if not m:
		return []

	tables = set()
	for t in m:
		t_temp = t.split('.')[0]
		t_temp = t_temp.replace('"', '')
		tables.add(t_temp)

	return list(tables)

def process_queries(workbooks):
	# */queries/*.sql,out,err
	tuples_regex = re.compile(r'^([0-9]+) tuples?$')
	unsupported_functions = [
		"DATE_PART".lower(),
		"DATE_TRUNC".lower(),
		"TABLEAU.TO_DATETIME".lower(),
		"TABLEAU.NORMALIZE_DATETIME".lower()]

	for wb in workbooks:
		wb["queries"] = []
		for f in os.listdir(os.path.join(wb["path"], "queries")):
			if not f.endswith('.sql'):
				continue
			q_info = {"name": f[:-len(".sql")], "output": {}, "query": {}}
			sql_f = os.path.join(wb["path"], "queries", "{}".format(f))
			with open(sql_f, 'r') as fd:
				q = fd.read().lower()
				q_info["query"]["disabled"] = q.startswith('--')
				q_info["query"]["unsupported"] = {uf: q.count(uf) for uf in unsupported_functions}
				q_info["query"]["tables"] = get_tables(q)
			out_f = os.path.join(wb["path"], "queries", "{}.out".format(q_info["name"]))
			err_f = os.path.join(wb["path"], "queries", "{}.err".format(q_info["name"]))
			if os.stat(out_f).st_size == 0:
				q_info["output"]["empty"] = True
			else:
				line = subprocess.check_output(['tail', '-1', out_f]).strip()
				m = tuples_regex.match(line)
				if m:
					q_info["output"]["tuples"] = int(m.group(1))
				else:
					q_info["output"]["error"] = "unable to parse output"
			# TODO: maybe also check error file
			wb["queries"].append(q_info)

def generate_report(workbooks):
	res = {
		"workbooks": [],
		"stats": {
			"nb_wbs_total": 0,
			"size_wbs_total_gb": 0,
			"wbs_fully_loaded": [],
			"nb_wbs_fully_loaded": 0,
			"size_wbs_fully_loaded_gb": 0,
			"wbs_full_query_results": [],
			"nb_wbs_full_query_results": 0,
			"wbs_fully_loaded_full_query_results": [],
			"nb_wbs_fully_loaded_full_query_results": 0,
			"size_wbs_fully_loaded_full_query_results_gb": 0,
			"nb_tables_total": 0,
			"nb_tables_fully_loaded": 0,
			"nb_queries_total": 0,
			"nb_queries_with_results": 0,
			"nb_queries_empty": 0,
			"nb_queries_successful": 0,
			"tables_used_in_sucessful_queries": [],
			"nb_tables_used_in_sucessful_queries": 0,
			"size_tables_used_in_sucessful_queries_gb": 0,
			"tables_not_used_in_sucessful_queries": [],
			"nb_tables_not_used_in_sucessful_queries": 0,
		}}

	# per workbook stats
	for wb in workbooks:
		summary = {
			"name": wb["name"],
			"nb_tables_total": 0,
			"nb_tables_successfully_loaded": 0,
			"ratio_tables_successfully_loaded": 0,
			"nb_tables_with_rejects": 0,
			"size_total_gb": 0,
			"size_successfully_loaded_gb": 0,
			"nb_queries_total": 0,
			"nb_queries_empty": 0,
			"nb_queries_successful": 0,
			"ratio_queries_successful": 0,
			"nb_queries_with_results": 0,
			"ratio_queries_with_results": 0,
			"used_tables": [],
			"size_used_tables": 0
		}

		# tables
		for t in wb["tables"]:
			summary["nb_tables_total"] += 1
			summary["size_total_gb"] += t["size_gb"]
			if t["load"]["ret"] == 0:
				summary["nb_tables_successfully_loaded"] += 1
				summary["size_successfully_loaded_gb"] += t["size_gb"]
			elif t["load"]["ret_reject"] == 0:
				summary["nb_tables_with_rejects"] += 1
			# check if referenced in queries
			for q in wb["queries"]:
				if t["name"].lower() in q["query"]["tables"]:
					summary["used_tables"].append(t["name"])
					summary["size_used_tables"] += t["size_gb"]
					res["stats"]["tables_used_in_sucessful_queries"].append("{}/{}".format(wb["name"], t["name"]))
					res["stats"]["nb_tables_used_in_sucessful_queries"] += 1
					res["stats"]["size_tables_used_in_sucessful_queries_gb"] += t["size_gb"]
					break
			else:
				res["stats"]["tables_not_used_in_sucessful_queries"].append("{}/{}".format(wb["name"], t["name"]))
				res["stats"]["nb_tables_not_used_in_sucessful_queries"] += 1

		# queries
		for q in wb["queries"]:
			summary["nb_queries_total"] += 1
			if "empty" in q["output"] and q["output"]["empty"] == True:
				summary["nb_queries_empty"] += 1
			elif "tuples" in q["output"]:
				summary["nb_queries_successful"] += 1
				if q["output"]["tuples"] > 0:
					summary["nb_queries_with_results"] += 1

		# ratios
		summary["ratio_tables_successfully_loaded"] = "+inf" if summary["nb_tables_total"] == 0 else \
			float(summary["nb_tables_successfully_loaded"]) / summary["nb_tables_total"]
		summary["ratio_queries_successful"] = "+inf" if summary["nb_queries_total"] == 0 else \
			float(summary["nb_queries_successful"]) / summary["nb_queries_total"]
		summary["ratio_queries_with_results"] = "+inf" if summary["nb_queries_total"] == 0 else \
			float(summary["nb_queries_with_results"]) / summary["nb_queries_total"]

		# general stats
		res["stats"]["nb_wbs_total"] += 1
		res["stats"]["size_wbs_total_gb"] += summary["size_total_gb"]
		res["stats"]["nb_tables_total"] += summary["nb_tables_total"]
		res["stats"]["nb_tables_fully_loaded"] += summary["nb_tables_successfully_loaded"]
		res["stats"]["nb_queries_total"] += summary["nb_queries_total"]
		res["stats"]["nb_queries_with_results"] += summary["nb_queries_with_results"]
		res["stats"]["nb_queries_empty"] += summary["nb_queries_empty"]
		res["stats"]["nb_queries_successful"] += summary["nb_queries_successful"]
		if summary["ratio_tables_successfully_loaded"] == 1:
			res["stats"]["wbs_fully_loaded"].append(summary["name"])
			res["stats"]["nb_wbs_fully_loaded"] += 1
			res["stats"]["size_wbs_fully_loaded_gb"] += summary["size_successfully_loaded_gb"]
		if summary["ratio_queries_successful"] == 1:
			res["stats"]["wbs_full_query_results"].append(summary["name"])
			res["stats"]["nb_wbs_full_query_results"] += 1
			if summary["ratio_tables_successfully_loaded"] == 1:
				res["stats"]["wbs_fully_loaded_full_query_results"].append(summary["name"])
				res["stats"]["nb_wbs_fully_loaded_full_query_results"] += 1
				res["stats"]["size_wbs_fully_loaded_full_query_results_gb"] += summary["size_successfully_loaded_gb"]

		# save result
		res["workbooks"].append(summary)

	return res

def output_report(workbooks, report):
	with open('./workbooks.json', 'w') as f:
		json.dump(workbooks, f, indent=2)
	with open('./report.json', 'w') as f:
		json.dump(report, f, indent=2)

	print "*** SUMMARY ***"

	print "\nnb_wbs_total: {}".format(report["stats"]["nb_wbs_total"])
	print "nb_wbs_fully_loaded: {}".format(report["stats"]["nb_wbs_fully_loaded"])
	print "size_wbs_total_gb: {}".format(report["stats"]["size_wbs_total_gb"])
	print "size_wbs_fully_loaded_gb: {}".format(report["stats"]["size_wbs_fully_loaded_gb"])

	print "\nnb_wbs_full_query_results: {}".format(report["stats"]["nb_wbs_full_query_results"])
	print "nb_wbs_fully_loaded_full_query_results: {}".format(report["stats"]["nb_wbs_fully_loaded_full_query_results"])
	print "size_wbs_fully_loaded_full_query_results_gb: {}".format(report["stats"]["size_wbs_fully_loaded_full_query_results_gb"])

	print "\nnb_tables_total: {}".format(report["stats"]["nb_tables_total"])
	print "nb_tables_fully_loaded: {}".format(report["stats"]["nb_tables_fully_loaded"])

	print "\nnb_queries_total: {}".format(report["stats"]["nb_queries_total"])
	print "nb_queries_successful: {}".format(report["stats"]["nb_queries_successful"])
	print "nb_queries_with_results: {}".format(report["stats"]["nb_queries_with_results"])
	print "nb_queries_empty: {}".format(report["stats"]["nb_queries_empty"])

	print "\nnb_tables_used_in_sucessful_queries: {}".format(report["stats"]["nb_tables_used_in_sucessful_queries"])
	print "size_tables_used_in_sucessful_queries_gb: {}".format(report["stats"]["size_tables_used_in_sucessful_queries_gb"])

	print "\nDetailed JSON formatted output can be found in ./workbooks.json and ./report.json"

def main():
	workbooks = get_workbook_info()
	process_load_data(workbooks)
	process_queries(workbooks)
	report = generate_report(workbooks)
	output_report(workbooks, report)

if __name__ == "__main__":
	main()
