#!/bin/bash

# (try to) load all CSV files into MonetDB

for i in */load.*.sql
do
	f=${i%.sql}
	t="${i##*/load.}"
	t="${t%.sql}"
	echo "$(date) $i"
	cut -d' ' -f2 "$i" \
	| sed 's|$| rows provided/expected|'

	# try normal "strict" COPY INTO
	mclient $i > $f.out 2> $f.err
	ret=$?
	echo $ret > $f.ret

	if [ "$ret" -ne 0 ]; then
		# in case of errors, resort to
		# less strict "best effort" variant
		echo "$(date) $i 'Best Effort'"
		{
			sed 's|;$| best effort;|' "$i"
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

	echo
done

echo "$(date)"
