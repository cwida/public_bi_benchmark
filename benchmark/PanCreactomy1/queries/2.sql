SELECT 
    "PanCreactomy1_1"."NPPES_PROVIDER_LAST_ORG_NAME" AS "NPPES_PROVIDER_LAST_ORG_NAME",
    "PanCreactomy1_1"."NPPES_PROVIDER_STATE" AS "NPPES_PROVIDER_STATE",
    "PanCreactomy1_1"."PROVIDER_TYPE" AS "PROVIDER_TYPE",   
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "PanCreactomy1_1"."AVERAGE_MEDICARE_PAYMENT_AMT")  AS "med:AVERAGE_MEDICARE_PAYMENT_AMT:ok",
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "PanCreactomy1_1"."AVERAGE_SUBMITTED_CHRG_AMT") AS "med:AVERAGE_SUBMITTED_CHRG_AMT:ok",
    SUM("PanCreactomy1_1"."AVERAGE_MEDICARE_PAYMENT_AMT") AS "sum:AVERAGE_MEDICARE_PAYMENT_AMT:ok", 
    SUM("PanCreactomy1_1"."LINE_SRVC_CNT") AS "sum:LINE_SRVC_CNT:ok" 
FROM "PanCreactomy1_1" 
WHERE (("PanCreactomy1_1"."PROVIDER_TYPE" IN ('General Surgery', 'Surgical Oncology')) 
    AND ("PanCreactomy1_1"."HCPCS_DESCRIPTION" IN ('Pancreas procedure', 'Partial removal of pancreas', 'Partial removal of pancreas with attachment to small bowel', 'Partial removal of pancreas, bile duct and small bowel with connection of pancreas to small bowel'))) 
GROUP BY 
    "PanCreactomy1_1"."NPPES_PROVIDER_LAST_ORG_NAME",   
    "PanCreactomy1_1"."NPPES_PROVIDER_STATE", 
    "PanCreactomy1_1"."PROVIDER_TYPE";
