#!/bin/env python

import sys, os
import re


def recover_group_by(query_orig, query_monetdbified):
	if query_monetdbified.startswith("--"):
		return query_monetdbified

	delim = " GROUP BY "
	tokens_orig = query_orig.split(delim)
	tokens_monetdbified = query_monetdbified.split(delim)

	if len(tokens_orig) < 2 or len(tokens_monetdbified) < 2:
		return query_monetdbified

	suffix_orig = tokens_orig[-1]
	prefix_monetdbified = delim.join(tokens_monetdbified[:-1])

	return "{}{}{};".format(prefix_monetdbified, delim, suffix_orig)


if __name__ == "__main__":

	if len(sys.argv) != 3:
		print "Usage: <orig_query_file> <MonetDBified_query_file>"
		sys.exit(1)

	with open(sys.argv[1], 'r') as q_1, open(sys.argv[2], 'r') as q_2:
		q_res = recover_group_by(q_1.read().strip(), q_2.read().strip())
		print q_res
