SELECT "IGlocations2_1"."Calculation_8090724143600502" AS "Calculation_8090724143600502",   "IGlocations2_1"."city" AS "city",   "IGlocations2_1"."state" AS "state",   SUM(CAST("IGlocations2_1"."Number of Records" AS BIGINT)) AS "sum:Number of Records:ok" FROM "IGlocations2_1" WHERE (("IGlocations2_1"."Calculation_8090724143600502" = 'Drunk') AND ("IGlocations2_1"."city" <> 'Unalaska') AND ("IGlocations2_1"."state" IN ('Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas')) AND ("IGlocations2_1"."Calculation_4370724142342227" = 'Beach')) GROUP BY 1,   2,   3;