# Public BI benchmark

User generated benchmark derived from the DBTest'18 paper [1] by Tableau. It contains real data an queries from 47 public workbooks in Tableau Public [2].

We downloaded 47 of the biggest workbooks and converted the data to *.csv* files and collected the SQL queries that appear in the Tableau log when the workbooks are visualized. We processed the *.csv* files and queries with the purpose of making them load and run on different database systems.

This repository contains samples and schema of each .csv file, the queries and a set of scripts for working with the benchmark. The full *.csv* files are available in compressed *bzip2* format at: http://www.cwi.nl/~boncz/PublicBIbenchmark/


## Benchmark

Each directory is associated with a workbook and contains:
```
samples:                      a sample of each *.csv* file (first 20 rows)
data-urls.txt:                links for downloading the full *.csv.bz2* compressed files
tables:                       .sql files containing the schema of each *.csv* file
queries-original:             original Tableau queries
queries-monetdb:              processed queries that work on MonetDB
queries-monetdb-disabled:     queries that do not work on MonetDB
queries-vectorwise:           processed queries that work on VectorWise
queries-vectorwise-disabled:  queries that do not work on VectorWise
```


## Scripts

### scripts/lib
- scripts that download and decompress the full data files

**1-download-data.sh** \<destination-dir\>\
    destination-dir:    path to directory where the dataset will be stored
- downloads the the full benchmark data files

**2-decompress-csv.sh**
- decompresses the *.csv.bz2* files
- script must be executed from the root directory of the dataset downloaded with **1-download-data.sh**

### scripts/monetdb
- scripts to create tables load *.csv* files and run the queries on MonetDB

Requirements:
- running MonetDB instance
- `mclient` command to be available and configured
- example of `mclient` configuration:
```
[user@machine ~]$ cat ~/.monetdb
user=monetdb
password=monetdb
language=sql
database=tpb
```

**monetdb/1-create-tables.sh**
- create the tables in MonetDB

**monetdb/2-load-data.sh** \<dataset-dir\>\
    dataset-dir:    path to dataset root directory
- loads the *.csv* files into MonetDB
- output files (*\*.out* and *\*.err*) in `<workbook>/load-monetdb/` contain the results of the queries
- expects the data files to be already decompressed (*.csv* not *.csv.bz2*)

**monetdb/3-run-queries.sh**
- runs the queries in MonetDB
- output files (*\*.out* and *\*.err*) in `<workbook>/queries-monetdb/` contain the results of the queries
- expects the data to be loaded into MonetDB

### scripts/vectorwise
- scripts to create tables load *.csv* files and run the queries on VectorWise

 Requirements:
 - running VectorWise instance
 - `sql` command to be available and configured

**vectorwise/1-create-tables.sh** \<database-name\>\
    database-name:    name of the database
- create the tables in MonetDB

**vectorwise/2-load-data.sh** \<database-name\> \<dataset-dir\>\
    database-name:    name of the database
  dataset-dir:      path to dataset root directory
- loads the *.csv* files into VectorWise
- output files (*\*.out* and *\*.err*) in `<workbook>/load-vectorwise/` contain the results of the queries
- expects the data files to be already decompressed (*.csv* not *.csv.bz2*)

**vectorwise/3-run-queries.sh** \<database-name\>\
    database-name:    name of the database
- runs the queries in VectorWise
- runs the queries in VectorWise
- output files (*\*.out*) in `<workbook>/queries-vectorwise/` contain the results of the queries
- expects the data to be loaded into VectorWise

### scripts/preprocess
- scripts and patches used to bring the benchmark to its current form; they are provided with the purpose of documenting the work done so far and to aid in future work
- see `scripts/preprocess/README.md` for more info


## Status

```
[27 February 2019]

47 workbooks containing 207 tables (.csv files)
41 GB compressed, 386 GB uncompressed

Multiple .csv files may overlap but are not identical. This is because Tableau
extracts the same workbook in multiple different ways for different queries.

905 queries in total:
monetdb:		646 working + 258 disabled
vectorwise:		605 working + 299 disabled

General errors:
- queries using non-existing columns
- queries on non-existing tables
- incomplete queries

MonetDB-specific errors:
- queries using functions not supported by MonetDB:
	- DATE_PART('WEEK:0', X), DATE_PART('DOW', X)
	- DATE_TRUNC
	- TABLEAU.TO_DATETIME
	- TABLEAU.NORMALIZE_DATETIME

VectorWise-specific errors:
- queries using functions not supported by VectorWise:
	- DATE_TRUNC
	- TABLEAU.TO_DATETIME
	- TABLEAU.NORMALIZE_DATETIME
- queries using LIMIT statements in subqueries
- queries generating errors because of ORDER BY statements

The queries that do not work are provided in the queries-monetdb-disabled and
queries-vectorwise-disabled directories of each workbook. Part of these queries
can be further processed and fixed.
```


## References

[1] Vogelsgesang, Adrian, et al. "Get real: How benchmarks fail to represent the real world." Proceedings of the Workshop on Testing Database Systems. ACM, 2018.\
[2] https://public.tableau.com
