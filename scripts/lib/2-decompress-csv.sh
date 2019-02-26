#!/bin/bash

for d in ./*; do
	cd $d
	for file in ./*.bz2; do
		echo "$(date) decompressing $file"
		bzip2 -dk $file &
	done
	cd ../
done
wait

echo "$(date) done"
