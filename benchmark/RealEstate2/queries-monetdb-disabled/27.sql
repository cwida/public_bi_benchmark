--SELECT "RealEstate2_7"."Postcode_Sector" AS "Postcode_Sector",   AVG(CAST(CAST("RealEstate2_7"."Price" AS BIGINT) AS double)) AS "avg:Price:ok",   COUNT(DISTINCT "RealEstate2_7"."Transaction_ID") AS "ctd:Transaction_ID:ok",   TABLEAU.TO_DATETIME(DATE_TRUNC('MONTH', TABLEAU.NORMALIZE_DATETIME("RealEstate2_7"."Date_of_Transfer")), "RealEstate2_7"."Date_of_Transfer") AS "tmn:Date_of_Transfer:ok" FROM "RealEstate2_7" WHERE (("RealEstate2_7"."Postcode_District" = 'NN4') AND ("RealEstate2_7"."Date_of_Transfer" >= cast('1996-01-01' as DATE)) AND ("RealEstate2_7"."Date_of_Transfer" < cast('2019-01-01' as DATE))) GROUP BY 1,   4;