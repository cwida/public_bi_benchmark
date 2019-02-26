#!/bin/bash

# (try to) load all CSV files into MonetDB

for f in */load-monetdb/*.sql
do
	echo "$(date) $f"

	t="$(basename $f)"; t="${t%.sql}"
	cut -d' ' -f2 "$f" \
	| sed 's|$| rows provided/expected|'

	# try normal "strict" COPY INTO
	mclient $f > $f.out 2> $f.err
	ret=$?
	echo $ret > $f.ret

	if [ "$ret" -ne 0 ]; then
		# in case of errors, resort to
		# less strict "best effort" variant
		echo "$(date) $f 'Best Effort'"
		{
			sed 's|;$| best effort;|' "$f"
			cat <<- EOF
				create table "$t-rejects" as (select * from rejects) with data;
				select count(distinct rowid), 'rows cause' from "$t-rejects"
				union all
				select count(*), 'rejects; saved in table $t-rejects' from "$t-rejects";
			EOF
		} \
		| mclient -ftab > $f-reject.out 2> $f-reject.err
		ret=$?
		echo $ret > $f-reject.ret
	fi
done

echo "$(date) done"
