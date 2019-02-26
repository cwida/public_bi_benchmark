#!/bin/env python

import sys, os
import re


'''
NOTE: subselects are problematic; match and treat only queries with LIMIT at the end of the query (with ';' or without)
'''
def convert_limit_syntax(query):
    regex_limit = re.compile(r'^SELECT (.*) LIMIT (\d+)(;?)$')

    m = regex_limit.match(query)
    if not m:
        return query

    return "SELECT FIRST {} {}{}".format(m.group(2), m.group(1), m.group(3))


if __name__ == "__main__":

    if len(sys.argv) != 2:
        print "Usage: <query_file>"
        sys.exit(1)

    with open(sys.argv[1], 'r') as q:
        q_res = convert_limit_syntax(q.read().strip())
        print q_res
