#!/bin/bash
#
# mode of operation:
# - click XXX.twbx file so it opens in Tablau;
# - click on all tabs in Tableau GUI
# - run this script passing in XXX as only parameter
# - close Tableau
# - manually move twbx file into /tmp/TableauPublic/$DB/ dir
#
DB=$1; export PGHOST=`fgrep -a 'no-password' hyperd.log  | tail -1 | awk -F 'tab.domain://' '{print $2}' | awk '{ print $1}' | sed 's/domain\/auto//'`; export PGPORT=`fgrep -a 'no-password' hyperd.log  | tail -1 | awk -F ',' '{print $2}' | awk -F ':' '{ print $2}'`; egrep -a -e CREATE -e SELECT hyperd.log | fgrep -a -v "FROM pg" | fgrep -a -v SCHEMAS_NAME | sed 's/"query-trunc":/"query":/g' | awk -F '"query":' '{ for(i=1;i<=NF;i++) if (match($i,"\"CREAT") || match($i,"\"SELECT")) print $i}' | sed 's/"//' | sed s/\"}}$// | sed 's/Extract (Extract.Extract)/Extract/g' | sed 's/\\\"Extract\\\".\\\"Extract\\\" \\\"E/\\\"E/g' |awk -F FOR '{ if (p1!=$1) print p; p=$0;p1=$1} END { if (match(p,"SELECT")) print p}' | awk '{ if (match($0, "CREATE TEMP EXTERNAL TABLE \\\\\"")) n++; gsub("\\\\\"Extract\\\\\"","\\\"Extract" n "\\\"", $0); print $0 }' | sed 's/\\\"/"/g'| sed 's/\\n/ /g' > /tmp/t; mkdir -p /tmp/TableauPublic/$DB; egrep -a -e "^SELECT" /tmp/t | fgrep -a -v "'::text) AS" | sed 's/FROM TABLEAU.NORMALIZE_DATETIME(/FROM /g' | sed 's/)) AS BIGINT OR NULL/) AS BIGINT/g' | sed 's/AS BIGINT OR NULL/AS BIGINT/g' | sed 's/NULLS FIRST//g' | sort | uniq > /tmp/TableauPublic/$DB/queries.sql; egrep -a -e "^CREATE" /tmp/t | awk 'BEGIN{ print "\\a";print "\\f ||"}{ d=$5; sub("Extract","Dummy",d); print $0 ";"; print "create temp table " d " as select * from " $5 " where false;"; print "\\d " d; print "\\o /tmp/TableauPublic/'$DB'/" $5 ".csv"; print "select * from " $5 ";"; print "\\o"}' | /Library/PostgreSQL/10/bin/psql -U tableau_internal_user > /tmp/TableauPublic/$DB/load.stdout 2> /tmp/TableauPublic/$DB/load.err; sed 's/||/|/g' /tmp/TableauPublic/$DB/load.stdout | sed 's/ "pg_temp./|pg_temp|"/' | fgrep -a -v 'Column|Type|Collation|Nullable|Default' | fgrep -a -v 'utput format is unaligned' | fgrep -a -v 'ield separator is' | egrep -a -v -e "^CREATE" | awk -F "|" '{ if ($1 == "Table" && $2 == "pg_temp") { if (t != "") printf "\n);\n"; l=""; t=$3; sub("Dummy","Extract",t); printf "CREATE TABLE %s(\n   ",t } else { sub("text","varchar",$2); sub("double precision","double",$2); printf "%s", l "\"" $1 "\" " $2; l=",\n   "}}END{printf "\n);\n"}' > /tmp/TableauPublic/$DB/tables.sql; mv hyperd.log log.txt /tmp/TableauPublic/$DB/

# issues
# - still some TABLEAU-specific datatime functions spotted that probably should be replaced by CAST
# - tables and columns get names with spaces, slashes and dots. This may not be allowed in all systems. Sanitize
# basic sanitize idea (but is not enough..) 
# egrep -v -e '^);' tables.sql | egrep -v -e '^CREATE' | awk '{ s=$1;gsub("\\\.","_",s); print "s/"$1"/"s"/g"}' t > /tmp/tt 
