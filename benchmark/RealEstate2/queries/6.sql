SELECT "RealEstate2_5"."Calculation_222787466264023043" AS "Calculation_222787466264023043",   "RealEstate2_5"."Street" AS "Street",   AVG(CAST(CAST("RealEstate2_5"."Price" AS BIGINT) AS double)) AS "avg:Price:ok",   SUM(1) AS "cnt:Date_of_Transfer:ok",   CAST(MAX("RealEstate2_5"."Price") AS BIGINT) AS "max:Price:ok" FROM "RealEstate2_5" WHERE ((position('THE BISHOPS AVENUE' in "RealEstate2_5"."Street")>0) AND ("RealEstate2_5"."County" = 'GREATER LONDON') AND ("RealEstate2_5"."Date_of_Transfer" >= cast('1996-01-01' as DATE)) AND ("RealEstate2_5"."Date_of_Transfer" < cast('2019-01-01' as DATE)) AND ("RealEstate2_5"."Postcode_District" = 'N2')) GROUP BY "RealEstate2_5"."Calculation_222787466264023043",   "RealEstate2_5"."Street";
