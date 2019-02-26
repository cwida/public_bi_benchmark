SELECT "PanCreactomy2_2"."NPPES_PROVIDER_GENDER" AS "NPPES_PROVIDER_GENDER",   "PanCreactomy2_2"."NPPES_PROVIDER_LAST_ORG_NAME" AS "NPPES_PROVIDER_LAST_ORG_NAME",   "PanCreactomy2_2"."NPPES_PROVIDER_STATE" AS "NPPES_PROVIDER_STATE",   "PanCreactomy2_2"."PROVIDER_TYPE" AS "PROVIDER_TYPE",   SUM("PanCreactomy2_2"."AVERAGE_MEDICARE_PAYMENT_AMT") AS "sum:AVERAGE_MEDICARE_PAYMENT_AMT:ok",   SUM("PanCreactomy2_2"."LINE_SRVC_CNT") AS "sum:LINE_SRVC_CNT:ok" FROM "PanCreactomy2_2" WHERE (("PanCreactomy2_2"."PROVIDER_TYPE" IN ('General Surgery', 'Surgical Oncology', 'Vascular Surgery')) AND ("PanCreactomy2_2"."HCPCS_DESCRIPTION" IN ('Pancreas procedure', 'Partial removal of pancreas', 'Partial removal of pancreas with attachment to small bowel', 'Partial removal of pancreas, bile duct and small bowel with connection of pancreas to small bowel'))) GROUP BY 1,   2,   3,   4;