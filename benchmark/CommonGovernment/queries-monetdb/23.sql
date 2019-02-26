SELECT CAST(EXTRACT(YEAR FROM (cast("CommonGovernment_4"."signeddate" as DATE) + 3 * INTERVAL '1' MONTH)) AS BIGINT) AS "yr:signeddate:ok" FROM "CommonGovernment_4" GROUP BY "yr:signeddate:ok";
