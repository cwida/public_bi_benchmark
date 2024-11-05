SELECT AVG(CAST(CAST("RealEstate1_1"."Price" AS BIGINT) AS double)) AS "avg:Price:ok" FROM "RealEstate1_1" WHERE ((CAST("RealEstate1_1"."Date of Transfer" as DATE) >= cast('2005-01-01' as DATE)) AND (CAST("RealEstate1_1"."Date of Transfer" as DATE) <= cast('2015-03-31' as DATE)) AND (CAST("RealEstate1_1"."Date of Transfer" as DATE) >= cast('1995-01-01' as DATE)) AND (CAST("RealEstate1_1"."Date of Transfer" as DATE) <= cast('2015-03-31' as DATE)) AND (CAST(EXTRACT(YEAR FROM "RealEstate1_1"."Date of Transfer") AS BIGINT) IN (2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014))) HAVING (COUNT(1) > 0);