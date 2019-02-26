#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
WORKING_DIR=$(pwd)

BASE_URL="http://www.cwi.nl/~boncz/PublicBIbenchmark"

usage() {
cat <<EOM
Usage: $(basename $0) <destination-dir>
  destination-dir    path to directory where the dataset will be stored
EOM
}

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi
DST_DIR="$1"

cd $DST_DIR
ret=$?
if [ $ret -ne 0 ]; then
    exit $ret
fi


mkdir -p "$DST_DIR/PublicBIbenchmark"

for wb_path in $SCRIPT_DIR/../../benchmark/*
do
    wb="$(basename $wb_path)"
    mkdir -p "$DST_DIR/PublicBIbenchmark/$wb"
    for f in $wb_path/samples/*
    do
        t="$(basename $f)"; t="${t%.sample.csv}"
        wget -P "$DST_DIR/PublicBIbenchmark/$wb" "$BASE_URL/$wb/$t.csv.bz2"
    done
done
