#!/bin/bash

# (try to) load all CSV files into MonetDB

for i in */queries/*.sql
do
	echo "$(date) $i"
	mclient -e -i -tperformance $i \
	 > ${i%.*}.out \
	2> ${i%.*}.err
done

echo "$(date)"
