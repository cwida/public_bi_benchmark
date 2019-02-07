#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
WORKING_DIR=$(pwd)

DATASET_URL="http://www.cwi.nl/~boncz/PublicBIbenchmark.tar"

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

printf "Downloading dataset..\n"
wget -O "PublicBIbenchmark.tar" $DATASET_URL

printf "\nExtracting dataset..\n"
tar -xvf "PublicBIbenchmark.tar"

printf "\nDataset location: $DST_DIR/PublicBIbenchmark (use this directory as parameter for the rest of the scripts)\n"
