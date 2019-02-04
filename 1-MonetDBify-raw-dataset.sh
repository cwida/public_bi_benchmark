#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
WORKING_DIR=$(pwd)

usage() {
cat <<EOM
Usage: $(basename $0) <dataset-dir>
  dataset-dir    path to dataset root directory
EOM
}

if [ "$#" -ne 1 ]; then
    usage
	exit 1
fi
DATASET_DIR="$1"

cd $DATASET_DIR
ret=$?
if [ $ret -ne 0 ]; then
	exit $ret
fi

# extract .csv files
for d in ./*; do
cd $d
	for file in ./*.bz2; do
		echo "$(date) extracting $file"
		bzip2 -dk $file &
	done
cd ../
done
wait

SCRIPTS="\
0-fix-tables_sql.sh \
1-MonetDBify-tables_sql.sh \
4-fix-csv.sh \
5-MonetDBify-csv.sh \
7-fix-queries_sql.sh \
8-MonetDBify-queries_sql.sh \
9-separate-queries.sh \
10-MonetDBify-queries_sql-2.sh"

for s in $SCRIPTS
do
	echo "$(date) running: $s"
	$SCRIPT_DIR/lib/$s
	ret=$?
	if [ "$ret" -ne 0 ]; then
		exit $ret
	fi
done
