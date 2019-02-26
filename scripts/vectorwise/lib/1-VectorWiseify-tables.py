#!/usr/bin/env python

import sys, os
import errno
import re

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
BENCHMARK_SRC_DIR = os.path.join(SCRIPT_DIR, "../../../benchmark")

DOUBLE_RE = re.compile(r'(.*) double(.*)')

def mkdir_p(dir_path):
	try:
		os.mkdir(dir_path)
	except OSError as e:
		if e.errno != errno.EEXIST:
			raise e


def process_line(line):
	r = DOUBLE_RE.match(line)
	if not r:
		return line

	return "{} float8{}".format(r.group(1), r.group(2))


def vectorwiseify_table(src_table_path, dst_table_path):
	with open (src_table_path, 'r') as src_f, open(dst_table_path, 'w') as dst_f:
		first_line = src_f.readline()
		dst_f.write(first_line)

		prev_l = src_f.readline()
		for l in src_f:
			res = process_line(prev_l.strip())
			if prev_l != res:
				print "{}\nold: {}new: {}".format(src_table_path, prev_l, res)
			dst_f.write("{}\n".format(res))
			prev_l = l

		last_line = prev_l
		dst_f.write(last_line)


if __name__ == "__main__":

	for d in os.listdir(BENCHMARK_SRC_DIR):
		src_wb_path = os.path.join(BENCHMARK_SRC_DIR, d, "tables")
		dst_wb_path = os.path.join(BENCHMARK_SRC_DIR, d, "tables-vectorwise")
		if not os.path.isdir(src_wb_path):
			print "error: unexpected file: {}".format(src_wb_path)
			continue

		mkdir_p(dst_wb_path)

		for f in os.listdir(src_wb_path):
			src_table_path = os.path.join(src_wb_path, f)
			if not os.path.isfile(src_table_path):
				print "error: unexpected directory: {}".format(src_table_path)
				continue

			dst_table_path = os.path.join(dst_wb_path, f)
			vectorwiseify_table(src_table_path, dst_table_path)
