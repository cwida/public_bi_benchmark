--SELECT TABLEAU.TO_DATETIME(DATE_TRUNC('HOUR', TABLEAU.NORMALIZE_DATETIME("Euro2016_1"."tweeted_at")), "Euro2016_1"."tweeted_at") AS "thr:tweeted_at:ok" FROM "Euro2016_1" GROUP BY 1 ORDER BY "thr:tweeted_at:ok" ASC ;