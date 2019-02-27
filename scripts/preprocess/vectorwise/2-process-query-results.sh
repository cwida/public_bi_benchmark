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


output_dir="$SCRIPT_DIR/2-process-query-results_output"
mkdir -p $output_dir && rm -f $output_dir/*

f_working="$output_dir/working.out"
f_error="$output_dir/error.out"
f_disabled="$output_dir/disabled.out"
f_exception="$output_dir/exception.out"

cnt_working=0
cnt_error=0
cnt_disabled=0
cnt_exception=0

for wb in ./*; do
    for q in $wb/queries/*.out; do
        q_name=$(basename $q); q_name="${q_name%.sql.out}"
        # echo $wb $q $q_name

        c_exec=`head -n 20 $q | grep -e "Executing" | wc -l`
        c_table1=`head -n 20 $q | grep -e "+--" | wc -l`
        c_table2=`head -n 20 $q | grep -e "--+" | wc -l`
        c_table3=`tail -n 20 $q | grep -e "+--" | wc -l`
        c_table4=`tail -n 20 $q | grep -e "--+" | wc -l`
        c_rows=`tail -n 20 $q | grep -E "([0-9]+ rows?)" | wc -l`

        # echo $c_exec $c_table1 $c_table2 $c_table3 $c_table4 $c_rows

        # working query
        if [[ "$c_exec" -gt "0" ]] && \
            [[ "$c_table1" -gt "0" ]] && \
            [[ "$c_table2" -gt "0" ]] && \
            [[ "$c_table3" -gt "0" ]] && \
            [[ "$c_table4" -gt "0" ]] && \
            [[ "$c_rows" -gt "0" ]]
        then
            cnt_working=$((cnt_working + 1))
            # echo "working"
            tmp=`tail -n 20 $q | grep -E "([0-9]+ rows?)"`
            echo "$q $tmp" >> $f_working
            continue
        fi

        # error in query
        if [[ "$c_exec" -gt "0" ]] && \
            [[ "$c_table1" -eq "0" ]] && \
            [[ "$c_table2" -eq "0" ]] && \
            [[ "$c_table3" -eq "0" ]] && \
            [[ "$c_table4" -eq "0" ]] && \
            [[ "$c_rows" -eq "0" ]]
        then
            cnt_error=$((cnt_error + 1))
            # echo "error"
            echo "$q" >> $f_error
            continue
        fi

        # disabled query
        if [[ "$c_exec" -eq "0" ]] && \
            [[ "$c_table1" -eq "0" ]] && \
            [[ "$c_table2" -eq "0" ]] && \
            [[ "$c_table3" -eq "0" ]] && \
            [[ "$c_table4" -eq "0" ]] && \
            [[ "$c_rows" -eq "0" ]]
        then
            cnt_disabled=$((cnt_disabled + 1))
            # echo "disabled"
            echo "$q" >> $f_disabled
            continue
        fi

        # unexpected case
        cnt_exception=$((cnt_exception + 1))
        echo "$q exception"
        echo $c_exec $c_table1 $c_table2 $c_table3 $c_table4 $c_rows
        echo "$q" >> $f_exception

    done
done

echo "cnt_working: $cnt_working"
echo "cnt_error: $cnt_error"
echo "cnt_disabled: $cnt_disabled"
echo "cnt_exception: $cnt_exception"
