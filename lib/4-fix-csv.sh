#!/bin/bash

# "fix" "broken" CSV files:
# with strings not being quoted,
# and the column separater '||'
# appearing unqouted in strings,
# we do some "simple" "crude" "magic"
# to resort correct CSV format

for i in \
	IUBLibrary/\"IUBLibrary_1\".csv
do
	echo "$(date) $i"
	sed -i \
	    -e 's/|||||||/||!!!||/' \
	    "$i"
done

for i in \
	Rentabilidad/\"Rentabilidad_?\".csv
do
	echo "$(date) $i"
	sed -i \
	    -e 's!\([^|]|\)|\(|[^|]\)!\1\2!' \
	    -e 's!\([^|]||\)|\(||[^|]\)!\1\2!' \
	    -e 's!\([^|0-9]\)||\(||1||OP||0||0||NO||0||0||0||\)!\1\2!' \
	    "$i"
done

for i in \
	YaleLanguages/\"YaleLanguages_?\".csv
do
	echo "$(date) $i"
	sed -i \
	    -e 's!\([^|]|\)|\(|[^|]\)!\1\2!g' \
	    -e 's!\([^|]||\)|||\(||[^|]\)!\1\2!g' \
	    -e 's!^||||\(||[am][ms]||\)!????\1!' \
	    -e 's!^\(19\)||\(||a[ms]||\)!\1??\2!' \
	    -e 's!\(||19\)||\(||19\)!\1??\2!g' \
	    -e 's!||||||||Unknown||Unknown||!||????||Unknown||Unknown||!' \
	    "$i"
done

echo "$(date)"

