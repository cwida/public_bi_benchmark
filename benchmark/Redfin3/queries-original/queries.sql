SELECT "Redfin3_1"."property_type" AS "property_type" FROM "Redfin3_1" GROUP BY 1 ORDER BY "property_type" ASC 
SELECT "Redfin3_2"."property_type" AS "property_type" FROM "Redfin3_2" GROUP BY 1 ORDER BY "property_type" ASC 
SELECT "Redfin3_2"."region" AS "region" FROM "Redfin3_2" GROUP BY 1 ORDER BY "region" ASC 
SELECT MIN(TABLEAU.TO_DATETIME(DATE_TRUNC('MONTH', TABLEAU.NORMALIZE_DATETIME("Redfin3_2"."period_end")), "Redfin3_2"."period_end")) AS "TEMP(tmn:period_end:qk lower)(290714814)(0)",   MAX(TABLEAU.TO_DATETIME(DATE_TRUNC('MONTH', TABLEAU.NORMALIZE_DATETIME("Redfin3_2"."period_end")), "Redfin3_2"."period_end")) AS "TEMP(tmn:period_end:qk upper)(290714814)(0)" FROM "Redfin3_2" HAVING (COUNT(1) > 0)
