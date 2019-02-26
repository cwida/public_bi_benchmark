#!/bin/bash

# create SQL load scripts for MonetDB
# using COPY INTO statements
# count of rows of CSV file

for d in */
do
	d="${d%/}"
	for f in "$d"/*.csv
	do
		echo "$(date) $f"

		t="${f##*/}"
		t="${t%.csv*}"
		# t="${t%.sample.csv*}"

		r="$(wc -l "$f")"; r="${r%% *}"
		echo "$r rows"

		mkdir -p "$d/load-monetdb"
		echo "copy $r offset 1 records into \"$t\" from '$PWD/$f' delimiters '|','\\n','' null as 'null' locked;" \
		> "$d/load-monetdb/$t.sql"
	done
done

echo "$(date) done"
