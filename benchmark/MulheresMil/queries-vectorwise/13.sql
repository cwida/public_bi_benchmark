SELECT CAST(EXTRACT(YEAR FROM "MulheresMil_1"."data_de_inicio") AS BIGINT) AS "yr:data_de_inicio:ok" FROM "MulheresMil_1" GROUP BY 1 ORDER BY "yr:data_de_inicio:ok" ASC;
