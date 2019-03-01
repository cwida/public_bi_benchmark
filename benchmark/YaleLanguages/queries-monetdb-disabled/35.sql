--SELECT "YaleLanguages_5"."Total Patron Circulation (copy) (copy)" AS "Total Patron Circulation (copy) (copy)",   SUM(CAST("YaleLanguages_5"."Number of Records" AS BIGINT)) AS "sum:Number of Records:ok" FROM "YaleLanguages_5" WHERE ((TABLEAU.NORMALIZE_DATETIME("YaleLanguages_5"."BIB_CREATE_DATE") <= cast('2003-01-01' as DATE)) AND ("YaleLanguages_5"."BIB_SUPPRESS_IN_OPAC" = 'N') AND ("YaleLanguages_5"."MFHD_SUPPRESS_IN_OPAC" = 'N')) GROUP BY 1;