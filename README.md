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
```sh
[user@machine ~]$ cat ~/.monetdb
user=monetdb
password=monetdb
language=sql
database=tpb
```
