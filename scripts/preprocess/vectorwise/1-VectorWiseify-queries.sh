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


: <<'END_COMMENT'
TODO: explain more thoroughly why:
	- first process queries for monetdb
	- then revert some of the changes (group by)
END_COMMENT


# separate original queries
for wb in ./*; do
    mkdir -p $wb/queries.orig
    awk -v str_var="$wb/queries.orig/%d.sql" '{filename = sprintf(str_var, NR); print >filename; close(filename)}' $wb/queries.sql
    cp "$wb/queries.sql" "$wb/queries.sql.orig"
done

# do all processing required for MonetDB
SCRIPTS="\
7-fix-queries_sql.sh \
8-MonetDBify-queries_sql.sh \
9-separate-queries.sh \
10-MonetDBify-queries_sql-2.sh"

for s in $SCRIPTS
do
    echo "$(date) running: $s"
    $SCRIPT_DIR/../monetdb/lib/$s
    ret=$?
    if [ "$ret" -ne 0 ]; then
        echo "error: ret=$ret"
        exit $ret
    fi
done

for wb in ./*; do
    mv $wb/queries $wb/queries.tmp
    cp -r $wb/queries.orig $wb/queries
done

# recover the group by part from the original queries
echo "$(date) recovering GROUP BY statements from original queries"
for wb in ./*; do
	for q in $wb/queries/*.sql; do
		q_name=$(basename $q)
		$SCRIPT_DIR/lib/recover-group_by.py $q $wb/queries.tmp/$q_name > $q.new
		ret=$?
		if [ $ret -ne 0 ]; then
			echo "error: unable to process query; ret=$ret"
			continue
		fi
		mv $q $q.orig
		mv $q.new $q
	done
done

# replace limit with first
echo "$(date) replacing LIMIT with FIRST"
for wb in ./*; do
    for q in $wb/queries/*.sql; do
        q_name=$(basename $q)
        $SCRIPT_DIR/lib/convert-limit-syntax.py $q > $q.new
        ret=$?
        if [ $ret -ne 0 ]; then
            echo "error: unable to process query; ret=$ret"
            continue
        fi
        mv $q.new $q
    done
done

# replace double with float8
echo "$(date) replacing double with float8"
for f in ./*/queries/*.sql; do
    sed 's/double/float8/g' $f > $f.new
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "error: unable to process query; ret=$ret"
        continue
    fi
    mv $f.new $f
done
