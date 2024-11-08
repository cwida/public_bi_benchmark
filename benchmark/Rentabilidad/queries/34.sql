SELECT 
    SUM("Rentabilidad_1"."CF") AS "TEMP(Calculation_0180826100354716)(2800871123)(0)",
    SUM("Rentabilidad_1"."VENTA: Costo Renta de Equipo Televenta Normal") AS "TEMP(Calculation_0180826100354716)(3086180950)(0)",
    SUM("Rentabilidad_1"."AUTOPREVENTA: Costo Variable") AS "TEMP(Calculation_1570826095201419)(2513675841)(0)",
    SUM("Rentabilidad_1"."OP. DISTRIBUIDORES: Mayoristas") AS "TEMP(Calculation_2870826100719945)(4185729228)(0)",
    SUM("Rentabilidad_1"."OTROS VENTA: Costo de Rotación Pre/Televendedores") AS "TEMP(Calculation_3200826100807006)(413541106)(0)",
    SUM("Rentabilidad_1"."PREVENTA: Costo de Prevendedor Normal") AS "TEMP(Calculation_3520826095610602)(3552190034)(0)",
    SUM("Rentabilidad_1"."VENTA: Costo de Handheld Rutas Autoventa") AS "TEMP(Calculation_4220826100057800)(3904289567)(0)",
    SUM("Rentabilidad_1"."OP. DISTRIBUIDORES: Costo Variable") AS "TEMP(Calculation_4240826100656862)(2193509658)(0)",
    SUM("Rentabilidad_1"."VENTA: Costos EDI") AS "TEMP(Calculation_4380826100509109)(1212524440)(0)",
    SUM("Rentabilidad_1"."CF") AS "TEMP(Calculation_4380826100509109)(3669921802)(0)",
    SUM("Rentabilidad_1"."OP. DISTRIBUIDORES: NO GVF") AS "TEMP(Calculation_4500826100734479)(4099618328)(0)",   
    SUM("Rentabilidad_1"."VENTA:  MERMA DE VENTA") AS "TEMP(Calculation_4570826095853475)(2671214433)(0)",
    SUM("Rentabilidad_1"."OP. DISTRIBUIDORES: Costo Fijo") AS "TEMP(Calculation_4620826100637396)(3791365069)(0)",
    SUM("Rentabilidad_1"."VENTA: Costo de Handheld Rutas NCBs") AS "TEMP(Calculation_5430826100119730)(2665247641)(0)",
    SUM("Rentabilidad_1"."VENTA: Costo de Handheld Rutas Preventa") AS "TEMP(Calculation_5940826100324565)(3497211172)(0)",
    SUM("Rentabilidad_1"."GERENTES VENTA: Costo Gerente de Ventas Normal"::DECIMAL(20,11)) AS "TEMP(Calculation_6420826095517474)(1366707666)(0)",
    SUM("Rentabilidad_1"."AUTOPREVENTA: Costo de Devoluciones") AS "TEMP(Calculation_6690826095031685)(3555310927)(0)",
    SUM(CAST("Rentabilidad_1"."VENTA: Costo Renta Equipo Televenta NCB" AS BIGINT)) AS "TEMP(Calculation_7340826100423216)(3617138799)(0)",
    SUM("Rentabilidad_1"."TELEVENTA: Costo de Televendedor Normal") AS "TEMP(Calculation_7640826095702871)(953446052)(0)",
    SUM("Rentabilidad_1"."PREVENTA NCB: Costo de Prevendedor NCB") AS "TEMP(Calculation_8060826095553370)(183941559)(0)",
    SUM(CAST("Rentabilidad_1"."VENTA: Coord, OL, Merc. 14" AS BIGINT)) AS "TEMP(Calculation_8340826095929147)(3051547965)(0)",
    SUM("Rentabilidad_1"."AUTOVENTA: Costo Variable") AS "TEMP(Calculation_8550826095421996)(2269316049)(0)",
    SUM("Rentabilidad_1"."AUTOVENTA: Carga Paseante") AS "TEMP(Calculation_8790826095231237)(2084891371)(0)",
    SUM("Rentabilidad_1"."AUTOVENTA: Costo Fijo") AS "TEMP(Calculation_9030826095312833)(1315964224)(0)",
    SUM(CAST("Rentabilidad_1"."TELEVENTA: Costo Televendedor NCB" AS BIGINT)) AS "TEMP(Calculation_9070826095815504)(2351785609)(0)",
    SUM(CAST("Rentabilidad_1"."VENTA: Descuentos Lista de Precios" AS BIGINT)) AS "TEMP(Calculation_9200826100549546)(488824060)(0)",
    SUM("Rentabilidad_1"."GERENTES VENTA: Coordinadores Bronces") AS "TEMP(Calculation_9450826095449976)(2325554751)(0)",
    SUM("Rentabilidad_1"."AUTOPREVENTA: Costo Fijo") AS "TEMP(Calculation_9460826095133318)(3706291980)(0)"
FROM "Rentabilidad_1"
WHERE (("Rentabilidad_1"."Sede Foraneo Sintec" = 'Foraneo')
       AND ("Rentabilidad_1"."Zona" = 'NR'))
HAVING (COUNT(1) > 0);
