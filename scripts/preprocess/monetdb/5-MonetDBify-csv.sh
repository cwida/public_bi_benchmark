#!/bin/bash

# MonetDB requires 'true' and 'false'
# rather than 't' and 'f' as boolean values

for i in \
	Telco/\"Telco_1\".csv \
	RealEstate2/\"RealEstate2_?\".csv
do
	echo "$(date) $i"
	sed -i \
	    -e 's!||t||!||true||!' \
	    -e 's!||f||!||false||!' \
	    "$i"
done

for i in \
	Eixo/\"Eixo_1\".csv \
	Uberlandia/\"Uberlandia_1\".csv \
	MulheresMil/\"MulheresMil_1\".csv
do
	echo "$(date) $i"
	sed -i \
	    -e 's!||t||!||true||!g' \
	    -e 's!||t||!||true||!g' \
	    -e 's!||f||!||false||!g' \
	    -e 's!||f||!||false||!g' \
	    "$i"
done

# MonetDB's bulk loader (COPY INTO) treats
# backslashes '\' "strangely" and "inconsistently"
# (inteprets some as escape sequences, others not);
# hence, we "crudely" just replicate all single
# backslashes '\' into double backslashes '\\'
# to (hopefully) prevent any (unwanted/inconsistent)
# interpretation

for i in \
	NYC/\"NYC_?\".csv \
	Motos/\"Motos_?\".csv \
	Generico/\"Generico_?\".csv
do
	echo "$(date) $i"
	sed -i \
	    -e 's|\([^\\]\)\\\([^\\]\)|\1\\\\\2|' \
	    "$i"
done

echo "$(date)"

