SELECT "Medicare2_2"."nppes_entity_code" AS "nppes_entity_code" FROM "Medicare2_2" WHERE ("Medicare2_2"."nppes_provider_state" = 'NY') GROUP BY 1 ORDER BY "nppes_entity_code" ASC;
