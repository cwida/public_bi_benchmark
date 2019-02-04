#!/bin/env python

import os, sys
import json
import re
from copy import deepcopy


def convert_tndt(param, default_datetime_field="DATE"):
	datetime_field_list = ["DATE", "TIMESTAMP", "TIME"]

	default = False
	for dtf in datetime_field_list:
		if dtf.lower() in param.lower():
			datetime_field = dtf
			break
	else:
		datetime_field = default_datetime_field
		default = True

	return (default, "CAST({} as {})".format(param, datetime_field))


def process_query(query):
	regex_tndt = re.compile(r'TABLEAU.NORMALIZE_DATETIME\((.*?)\)')
	prefix, suffix = "TABLEAU.NORMALIZE_DATETIME(", ")"

	if query.startswith("--"):
		query = query[2:]

	end_pos = 0
	while True:
		m = regex_tndt.search(query, pos=end_pos)
		if not m:
			break
		start_pos, end_pos = m.start(1), m.end(1)
		(default, res) = convert_tndt(m.group(1))
		query = query[:start_pos-len(prefix)] + res + query[end_pos+len(suffix):]

	return query


def main():
	if len(sys.argv) != 2:
		print "Usage: ./fix-group-by.py <path to query file>"
		sys.exit(1)

	with open(sys.argv[1], 'r') as f:
		query = f.read().strip('\r\n\t ')
		new_query = process_query(query)
		sys.stdout.write(new_query)
		sys.stdout.flush()


if __name__ == "__main__":
	main()
