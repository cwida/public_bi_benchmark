SELECT "Motos_2"."Marca" AS "Datos (copia)",   SUM("Motos_2"."InversionUS") AS "TEMP(TC_)(2622528870)(0)",   "Motos_2"."Vehiculo" AS "Vehiculo",   SUM("Motos_2"."InversionUS") AS "sum:Calculation_0061002123102817:ok",   SUM(CAST("Motos_2"."NumAnuncios" AS BIGINT)) AS "sum:NumAnuncios:ok",   CAST(EXTRACT(YEAR FROM "Motos_2"."FECHA") AS BIGINT) AS "yr:FECHA:ok" FROM "Motos_2" WHERE ((CAST(EXTRACT(YEAR FROM "Motos_2"."FECHA") AS BIGINT) = 2015) AND ("Motos_2"."Categoria" = 'MOTOCICLETAS') AND ("Motos_2"."Medio" = 'RADIO')) GROUP BY "Motos_2"."Marca",   "Motos_2"."Vehiculo",   "yr:FECHA:ok";