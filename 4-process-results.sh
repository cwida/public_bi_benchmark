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

$SCRIPT_DIR/lib/12-process-results.py
ret=$?
if [ $ret -ne 0 ]; then
        exit $ret
fi

mv report.json workbooks.json $WORKING_DIR

