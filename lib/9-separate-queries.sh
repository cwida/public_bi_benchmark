#!/bin/bash

# separate queries into multiple files

for wb in ./*; do
	mkdir -p $wb/queries
	awk -v str_var="$wb/queries/%d.sql" '{filename = sprintf(str_var, NR); print >filename; close(filename)}' $wb/queries.sql
	mv "$wb/queries.sql" "$wb/queries.sql.tmp"
done
