#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
WORKING_DIR=$(pwd)


mclient --version > /dev/null
ret=$?
if [ "$ret" -ne 0 ]; then
	echo "error: unable to connect to MonetDB"
	exit $ret
fi


for f in $SCRIPT_DIR/../../benchmark/*/tables/*.table.sql
do
	echo "$(date) $f"
	mclient $f
	ret=$?
	echo $ret > "$f.ret"
done


echo "$(date) done"
