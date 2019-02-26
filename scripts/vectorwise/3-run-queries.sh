#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
WORKING_DIR=$(pwd)


usage() {
cat <<EOM
Usage: $(basename $0) <database-name>
  database-name    name of the database
EOM
}

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi
DB_NAME="$1"

echo "help tm\g" | sql $DB_NAME > /dev/null
ret=$?
if [ "$ret" -ne 0 ]; then
    echo "error: unable to connect to database"
    exit $ret
fi


for f in $SCRIPT_DIR/../../benchmark/*/queries-vectorwise/*.sql
do
    echo "$(date) $f"
    query="$(cat $f)\g"
    echo $query | sql $DB_NAME > "$f.out" 2> "$f.err"
    ret=$?
    echo $ret > "$f.ret"
done


echo "$(date) done"
