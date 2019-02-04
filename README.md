# Tableau benchmark
A set of scripts to download, process, load and run the Tableau Benchmark data and queries on MonetDB.

### Scripts
**0-get-raw-dataset.sh** \<destination-dir>\
    destination-dir:    path to directory where the dataset will be stored
- downloads and extracts the data
- in this form, part of the data will not load and the queries will not run

**1-MonetDBify-raw-dataset.sh** \<dataset-dir>\
    dataset-dir:    path to dataset root directory
- fixes csv files
- alters queries to work on MonetDB
- disables queries that cannot be fixed
- final queries are in the *\<workbook\>/queries/* directory (one query per file)

**2-MonetDB-load-data.sh** \<dataset-dir>\
    dataset-dir:    path to dataset root directory
- creates tables in MonetDB
- loads data into MonetDB
- output files (\*.out and \*.err) in each workbook directory contain the result of the load operation
- see Notes section for requirements

**3-MonetDB-run-queries.sh** \<dataset-dir>\
    dataset-dir:    path to dataset root directory
- runs the queries on MonetDB
- expects the data to be loaded
- output files (\*.out and \*.err) in *\<workbook\>/queries/* contain the result of the queries
- see Notes section for requirements

**4-process-results.sh** \<dataset-dir>\
    dataset-dir:    path to dataset root directory
- processes the output files of scripts 2 and 3
- generates a report based on it: 2 JSON formatted files in the current directory (workbooks.json, report.json)

### Notes
Requirements for scripts 2 and 3:
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

### Status
```
[04-02-2019]

212 (422 GB)    total tables
=
198 (405 GB)    load successfully
- 168 (396 GB)  used in successful queries
14 (17 GB)      error on loading

912         total queries
=
622 (68%)   queries work AND produce results (nb_rows > 0)
38  (4%)    queries work BUT do not produce results (nb_rows = 0)
156 (17%)   impossible to fix (129 + 3 + 16 + 8)
               - 137 queries using non-existing columns (122+7+8)
               - 3 queries on non-existing tables
               - 16 incomplete queries
96  (10%)   queries using functions not supported by MonetDB
```
