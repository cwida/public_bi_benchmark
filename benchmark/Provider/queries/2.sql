SELECT "Provider_2"."nppes_provider_city" AS "nppes_provider_city" FROM "Provider_2" WHERE (("Provider_2"."nppes_provider_state" = 'WA') AND ("Provider_2"."provider_type" = 'Nephrology')) GROUP BY "Provider_2"."nppes_provider_city";