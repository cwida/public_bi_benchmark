SELECT "Medicare2_2"."provider_type" AS "provider_type" FROM "Medicare2_2" WHERE ("Medicare2_2"."nppes_provider_state" = 'NY') GROUP BY 1 ORDER BY "provider_type" ASC;
