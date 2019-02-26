#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
WORKING_DIR=$(pwd)


usage() {
cat <<EOM
Usage: $(basename $0) <database-name> <dataset-dir>
  database-name    name of the database
  dataset-dir      path to dataset root directory
EOM
}

if [ "$#" -ne 2 ]; then
	usage
	exit 1
fi
DB_NAME="$1"
DATASET_DIR="$2"

echo "help tm\g" | sql $DB_NAME > /dev/null
ret=$?
if [ "$ret" -ne 0 ]; then
	echo "error: unable to connect to database"
	exit $ret
fi

cd $DATASET_DIR
ret=$?
if [ $ret -ne 0 ]; then
	exit $ret
fi


for wb in ./*
do
	for f in ./$wb/*.csv
	do
		echo "$(date) $f"
		filename=$(basename -- "$f")
		table="${filename%.*}"; table="${table%\"}"; table="${table#\"}"
		# table="${filename%.sample*}"; table="${table%\"}"; table="${table#\"}"

		# NOTE: set --errcount to the number of rows
		# 		- this is neccessary because --errcount 0 does not work as expected (no rows are loaded if there are errors)
		r="$(wc -l "$f")"; r="${r%% *}"
		echo "$r rows"

        mkdir -p "$wb/load-vectorwise"
		vwload --fdelim "|" --nullvalue "null" --errcount "$r" --log "$wb/load-vectorwise/$table.load.log" -z --table "$table" pbib "$f" > "$wb/load-vectorwise/$table.load.out" 2> "$wb/load-vectorwise/$table.load.err"
		ret=$?
		echo $ret > "$wb/load-vectorwise/$table.load.ret"
	done
done


echo "$(date) done"
