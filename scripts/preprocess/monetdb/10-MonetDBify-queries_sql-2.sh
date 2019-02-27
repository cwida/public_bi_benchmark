#!/bin/bash

DIR=$(dirname "$(realpath "$0")")

# replace column numbers by column names in GROUP BY
MLB_queries="117 113 109 108 112 111 114 49"
for q in $MLB_queries
do
	q_sql="MLB/queries/${q}.sql"
	echo "fixing query:" $q_sql
	$DIR/util/fix-group-by.py $q_sql > "${q_sql}.new"
	mv "${q_sql}.new" $q_sql
done

MulheresMil_queries="26 28 4 23 2"
for q in $MulheresMil_queries
do
	q_sql="MulheresMil/queries/${q}.sql"
	echo "fixing query:" $q_sql
	$DIR/util/fix-group-by.py $q_sql > "${q_sql}.new"
	mv "${q_sql}.new" $q_sql
done


# 1) fix TABLEAU.NORMALIZE_DATETIME; 2) replace column numbers by column names in GROUP BY
YaleLanguages_queries="9 31 25 12 5 8"
# no such column: 19 36 34 35 41 20 22
for q in $YaleLanguages_queries
do
	q_sql="YaleLanguages/queries/${q}.sql"
	echo "fixing query:" $q_sql
	$DIR/util/fix-tableau-normalize-datetime.py $q_sql > "${q_sql}.new1"
	$DIR/util/fix-group-by.py "${q_sql}.new1" > "${q_sql}.new2"
	rm "${q_sql}.new1"
	mv "${q_sql}.new2" $q_sql
done


# apply patches
W_DIR=$(pwd)
for wb in Eixo Uberlandia MulheresMil MLB RealEstate1 Arade TrainsUK1 YaleLanguages
do
	echo "fixing workbook: ${wb}"
	cd $W_DIR/$wb/queries
	for f in $DIR/10-MonetDBify-queries_sql-2/$wb/*
	do
		cp $f .
		p=$(basename $f)
		patch -p0 < $p
		rm ./$p
	done
	cd $W_DIR
done
