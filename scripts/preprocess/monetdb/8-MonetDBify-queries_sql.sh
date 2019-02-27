#!/bin/bash

DIR=$(dirname "$(realpath "$0")")

# - terminate queries with ';'
# - remove non-supported 'COLLATE "..."'
# - remove non-supported 'NULLS LAST'
# - "X::TYPE "            => "cast(X as TYPE)"
# - "null::TYPE"          => "null" (no cast required)
# - "(DATE 'YYYY-MM-DD')" => "cast('YYYY-MM-DD' as date)"
# - "DATE(...)"           => "cast(... as date)"
# - "INTERVAL 'n YMDMS'"  => "INTERVAL 'n' YMDMS"
# - "BTRIM(...,E'...')"   => "trim(...,'...')"
# - "TABLEAU.SPLIT_PART"  => "splitpart"
# - "TABLEAU.ROUND"       => "round"
# - "CONTAINS(...,'...')" => "(locate('...',...) > 0)
# - "(a IS NOT DISTINCT FROM b)" => "((a = b) or (a is null and b is null))"
# - disable 125 queries using non-supported / unknown
#   + "DATE_PART()"
#   + "DATE_TRUNC()"
#   + "TABLEAU.TO_DATETIME()"
#   + "TABLEAU.NORMALIZE_DATETIME()"
sed -i \
	-e 's|\([^;]\)$|\1;|' \
	-e 's| COLLATE "[^"]*"||g' \
	-e 's| NULLS LAST\([ ;]\)|\1|g' \
	-e "s|\([ (]\)\('[^']*'\)::\([^) ]*\)\([) ]\)|\1cast(\2 as \3)\4|g" \
	-e 's|\(NOW()\)::\(TIMESTAMP\)|cast(\1 as \2)|g' \
	-e 's|\(ELSE \)\(null\)::\([a-z]*\)\( END\)|\1\2\4|g' \
	-e "s|(\(DATE\) \('[^']*'\))|cast(\2 as \1)|g" \
	-e "s|\(DATE\)(\([^)]*\))|cast(\2 as \1)|g" \
	-e "s|\(INTERVAL '[0-9]*\)\( [A-Z]*\)'|\1'\2|g" \
	-e "s|BTRIM(\(.*\),E\('[^']*'\))|trim(\1,\2)|g" \
	-e 's|TABLEAU.SPLIT_PART|splitpart|g' \
	-e 's|TABLEAU.ROUND|round|g' \
	-e "s|CONTAINS(\([^']*\), *\('[^']*'\))|(locate(\2,\1)>0)|g" \
	-e 's|(\([^()]*\) IS NOT DISTINCT FROM \([^()]*\))|((\1 = \2) or (\1 is null and \2 is null))|g' \
	-e 's|^\([^\-].*DATE_PART *(\)|--\1|' \
	-e 's|^\([^\-].*DATE_TRUNC *(\)|--\1|' \
	-e 's|^\([^\-].*TABLEAU.TO_DATETIME *(\)|--\1|' \
	-e 's|^\([^\-].*TABLEAU.NORMALIZE_DATETIME *(\)|--\1|' \
	*/queries.sql



# - replace column numbers by column names in GROUP BY
#   + multiple GROUP BY per line, i.e., GROUP BY also in subqueries
patch -p0 < $DIR/8-MonetDBify-queries_sql.patch-1
#   + only one GROUP BY per line
#     * "GROUP BY 1, 2, 4"
sed -i \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", \)\("*[^,]*"\)\( AS "[^"]*", *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*" FROM .* GROUP BY[^Y]* \)1, *2, *4\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", \)\("*[^,]*"\)\( AS "[^"]*", *[^,]* AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1, *2, *4\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\(, *[^,]* AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1, *2, *4\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	*/queries.sql
#     * "GROUP BY 1, 2, 3"
sed -i \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", \)\("*[^,]*"\)\( AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*" FROM .* GROUP BY[^Y]* \)1, *2, *3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", \)\("*[^,]*"\)\( AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1, *2, *3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\(, *[^,]* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1, *2, *3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\(, *\)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1, *2, *3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", \)\("*[^,]*"\)\( AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)1, *2, *3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\6\7\2, \4, \6\8!' \
	*/queries.sql
#     * "GROUP BY 1, 3"
sed -i \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*" FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT [^,]* AS \)\("[^"]*"\)\(, *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*" FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT [^,]* AS \)\("[^"]*"\)\(, *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT [^,]* AS \)\("[^"]*"\)\(, *[^,]* AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1\(, *\)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	*/queries.sql
#     * "GROUP BY 1, 2"
sed -i \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*" FROM .* GROUP BY[^Y]* \)1\(, *\)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *\)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1\(, *\)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", *[^,]* AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)1\(, *\)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	-e 's!^\(SELECT [^,]* AS \)\("[^"]*"\)\(, *\)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1\(, *\)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6\4\7!' \
	*/queries.sql
#     * "GROUP BY 3"
sed -i \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *[^,]* AS "[^"]*", *CAST(\)\("[^,]*"\)\( AS [a-zA-Z]*) AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *[^,]* AS "[^"]*", *\)\([^,]*\)\( AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\4\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *[^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *[^,]* AS "[^"]*", *CAST(\)\("[^,]*"\)\( AS [a-zA-Z]*) AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *[^,]* AS "[^"]*", *\)\([^,]*\)\( AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)3\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\4\6!' \
	*/queries.sql
#     * "GROUP BY 2"
sed -i \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *CAST(\)\("[^,]*"\)\( AS [a-zA-Z]*) AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *\)\([^,]*\)\( AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\4\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *\)\("[^,]*"\)\( AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *CAST(\)\("[^,]*"\)\( AS [a-zA-Z]*) AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\2\6!' \
	-e 's!^\(SELECT [^,]* AS "[^"]*", *\)\([^,]*\)\( AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)2\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\4\5\4\6!' \
	*/queries.sql
#     * "GROUP BY 1"
sed -i \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*" FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	-e 's!^\(SELECT CAST(\)\("[^,]*"\)\( AS [a-zA-Z]*) AS "[^"]*" FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	-e 's!^\(SELECT [^,]* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	-e 's!^\(SELECT \)\("[^,]*"\)\( AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	-e 's!^\(SELECT CAST(\)\("[^,]*"\)\( AS [a-zA-Z]*) AS "[^"]*", .* FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	-e 's!^\(SELECT [^,]* AS \)\("[^"]*"\)\(, .* FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	-e 's!^\(SELECT .* AS \)\("[^"]*"\)\( FROM .* GROUP BY[^Y]* \)1\( *;\| * HAVING .*\| * ORDER BY .*\| * LIMIT .*\)$!\1\2\3\2\4!' \
	*/queries.sql
#   + and more "by hand"
patch -p0 < $DIR/8-MonetDBify-queries_sql.patch-2
