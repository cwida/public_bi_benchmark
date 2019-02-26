SELECT CAST(EXTRACT(YEAR FROM (cast("CommonGovernment_2"."signeddate" as DATE) + 3 * INTERVAL '1' MONTH)) AS BIGINT) AS "yr:signeddate:ok" FROM "CommonGovernment_2" GROUP BY "yr:signeddate:ok";
