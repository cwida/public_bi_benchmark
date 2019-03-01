# Public BI benchmark

User generated benchmark derived from the DBTest'18 paper [1] by Tableau. It contains real data and queries from 47 public workbooks in Tableau Public [2].

We downloaded 47 of the biggest workbooks and converted the data to *.csv* files and collected the SQL queries that appear in the Tableau log when the workbooks are visualized. We processed the *.csv* files and queries with the purpose of making them load and run on different database systems.

This repository contains samples and schema of each .csv file, the queries and a set of scripts for working with the benchmark. The full *.csv* files are available in compressed *bzip2* format at: http://www.cwi.nl/~boncz/PublicBIbenchmark/

Each directory is associated with a workbook and contains:
```
samples:                      a sample of each .csv file (first 20 rows)
data-urls.txt:                links for downloading the full .csv.bz2 compressed files
tables:                       .sql files containing the schema of each .csv file
queries-original:             original Tableau queries
queries-monetdb:              processed queries that work on MonetDB
queries-monetdb-disabled:     queries that do not work on MonetDB
queries-vectorwise:           processed queries that work on VectorWise
queries-vectorwise-disabled:  queries that do not work on VectorWise
```

There are 47 workbooks containing 207 tables (.csv files) with the total size of 41 GB compressed and 386 GB uncompressed.

Multiple .csv files may overlap but are not identical. This is because Tableau
extracts the same workbook in multiple different ways for different queries.

The benchmark contains 646 queries which have been tested on MonetDB. The same queries with VectorWise specific syntax are available on the `dev/master` branch.

Note: AirlineSentiment has no working queries. However, we keep it for the data and the compression use case.

## References

[1] Vogelsgesang, Adrian, et al. "Get real: How benchmarks fail to represent the real world." Proceedings of the Workshop on Testing Database Systems. ACM, 2018.\
[2] https://public.tableau.com
