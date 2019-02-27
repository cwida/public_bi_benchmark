#!/bin/env python

import os, sys
import json
import re
from copy import deepcopy


def get_column_name(select_items, group_by_item):
	group_by_item = group_by_item.strip()

	try:
		col_index = int(group_by_item) - 1
	except Exception as e:
		return group_by_item

	tokens = select_items[col_index].split(" AS ")
	if len(tokens) < 2:
		sys.stderr.write("error: query format does not match; details: as\n")
		sys.exit(1)

	return tokens[-1].strip()


def process_query_v1(query):
	regex_query = re.compile(r'^SELECT (.*?) FROM (.*?) GROUP BY (.*?);?$')

	if query.startswith("--"):
		sys.stderr.write("error: query is disabled\n")
		sys.exit(1)

	m = regex_query.match(query)
	if not m or query.count("SELECT") != 1 or query.count("FROM") != 1 or query.count("GROUP BY") != 1:
		sys.stderr.write("error: query format does not match; details: select->from->group_by\n")
		sys.exit(1)

	select_items = m.group(1).split(",")
	group_by_items = m.group(3).split(",")
	# print "select_items: {}".format(json.dumps(select_items, indent=2))
	# print "group_by_items: {}".format(json.dumps(group_by_items, indent=2))

	new_group_by_items = map(lambda item: get_column_name(select_items, item), group_by_items)
	# print "new_group_by_items: {}".format(json.dumps(new_group_by_items, indent=2))
	new_group_by_items = ", ".join(new_group_by_items)
	# print "new_group_by_items: {}".format(new_group_by_items)

	new_query = "SELECT {} FROM {} GROUP BY {}".format(m.group(1), m.group(2), new_group_by_items)
	if query[-1] == ";":
		new_query += ";"

	return new_query


def process_query_v2(query):
	if query.startswith("--"):
		sys.stderr.write("error: query is disabled\n")
		sys.exit(1)
	if not query.startswith("SELECT ") or query.count("SELECT") > 1:
		sys.stderr.write("error: query format does not match; details: select\n")
		sys.exit(1)

	query_tmp = deepcopy(query)
	query_tmp = query_tmp[len("SELECT "):]

	tokens = query_tmp.split(" FROM ")
	if len(tokens) == 0:
		sys.stderr.write("error: query format does not match; details: from\n")
		sys.exit(1)
	select_data = tokens[0]

	tokens = query_tmp.split(" GROUP BY ")
	if len(tokens) == 0:
		sys.stderr.write("error: query format does not match; details: group by\n")
		sys.exit(1)
	group_by_data = tokens[-1]
	prefix_data = " GROUP BY ".join(tokens[:-1])

	select_items = select_data.split(",")
	group_by_items = group_by_data.split(",")
	# print "select_items: {}".format(json.dumps(select_items, indent=2))
	# print "group_by_items: {}".format(json.dumps(group_by_items, indent=2))

	new_group_by_items = map(lambda item: get_column_name(select_items, item), group_by_items)
	# print "new_group_by_items: {}".format(json.dumps(new_group_by_items, indent=2))
	new_group_by_data = ", ".join(new_group_by_items)
	# print "new_group_by_data: {}".format(new_group_by_data)

	new_query = "{}  GROUP BY {}".format(prefix_data, new_group_by_data)

	return new_query


def main():
	if len(sys.argv) != 2:
		print "Usage: ./fix-group-by.py <path to query file>"
		sys.exit(1)

	with open(sys.argv[1], 'r') as f:
		query = f.read().strip('\r\n\t ')
		new_query = process_query_v1(query)
		sys.stdout.write(new_query)
		sys.stdout.flush()


if __name__ == "__main__":
	main()
