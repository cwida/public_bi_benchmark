#!/bin/bash

# create SQL load scripts for MonetDB
# using COPY INTO statements:
# OFFSET 2 skips the CSV header line
# extract number of rows from CSV file

for d in */
do
	d="${d%/}"
	for f in "$d"/*.csv
	do
		t="${f##*/}"
		t="${t%.csv*}"
		t="${t#\"}"
		t="${t%\"}"
		echo -ne "$(date) $f \t tail: "
		# check whether CSV file gives
		# number of rows in last line
		r="$(
			tail -n1 "$f" \
			| grep '^([0-9]* rows*)$' \
			| sed 's|^(\([0-9]*\) rows*)$|\1|'
		)"
		echo -ne "${r:-?} rows"
		test "$r" || {
			# incomplete CSV file:
			# number of rows missing
			# and last line truncated;
			# let `wc` count the rows
			echo -ne "\t wc: "
			r="$(wc -l "$f")"
			r="${r%% *}"
			# skip header line and
			# truncated last line
			r="$[r-2]"
			echo -ne "$r rows"
		}
		echo
		echo "copy $r offset 2 records into \"$t\" from '$PWD/$f' delimiters '||','\\n','' null as '' locked;" \
		> "$d/load.$t.sql"
	done
done
echo "$(date)"

