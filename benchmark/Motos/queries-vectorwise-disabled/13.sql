--SELECT "Motos_2"."Marca" AS "Datos (copia)",   MAX("Motos_2"."Vehiculo") AS "TEMP(attr:Vehiculo:nk)(1662645443)(0)",   MIN("Motos_2"."Vehiculo") AS "TEMP(attr:Vehiculo:nk)(536654816)(0)",   SUM((CAST("Motos_2"."Cols" AS BIGINT) * CAST("Motos_2"."Plgs" AS BIGINT))) AS "sum:Calculation_1450626233922327:ok",   SUM(CAST("Motos_2"."NumAnuncios" AS BIGINT)) AS "sum:NumAnuncios:ok",   TABLEAU.TO_DATETIME(DATE_TRUNC('DAY', TABLEAU.NORMALIZE_DATETIME("Motos_2"."FECHA")), "Motos_2"."FECHA") AS "tdy:FECHA:ok" FROM "Motos_2" WHERE (("Motos_2"."Categoria" IN ('CAMIONES', 'CAMIONES, BUSES Y PANELES', 'MOTOCICLETAS', 'PICK UPS, VANS Y JEEPS', 'PICK-UPS', 'SUV Y JEEPS', 'VEHICULOS NUEVOS')) AND (CAST(EXTRACT(YEAR FROM "Motos_2"."FECHA") AS BIGINT) >= 2010) AND (CAST(EXTRACT(YEAR FROM "Motos_2"."FECHA") AS BIGINT) <= 2015) AND (CAST(EXTRACT(YEAR FROM "Motos_2"."FECHA") AS BIGINT) = 2015) AND ("Motos_2"."Categoria" = 'MOTOCICLETAS') AND ("Motos_2"."Medio" = 'PRENSA')) GROUP BY 1,   6;