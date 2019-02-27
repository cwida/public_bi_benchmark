# scripts/preprocess

A set of scripts and patches used to bring the benchmark to its current form. They are provided with the purpose of documenting the work done so far and to aid in future work.

These scripts work on the initial dataset. The directory structure is as follows:
- one directory for each workbook; one *.csv.bz2* file for each table of each workbook
```
<workbook>/"<table>".csv.bz2
<workbook>/tables.sql
<workbook>/queries.sql
<workbook>/hyperd.log
```

Scripts contain comments and are self-explanatory (to some extent). Numbered scripts are meant to be executed in order.


### monetdb

All the scripts must be executed from the root directory of the dataset. The data files must be already decompressed (*.csv* not *.csv.bz2*).

The scripts alter the *.csv* files and queries. Some changes are generic and some are tailored to MonetDB specifics.

Work that has been done and is not included in these scrips:
- generate `<workbook>/tables/*` files based on the tables.sql; this includes converting *string* to *varchar(n)* and some *double* columns to *decimal(p, s)* (the parameters were inferred from the *.csv* files)
- remove tables and *.csv* files that do not load at all
- manually disable some of the queries in `<workbook>/queries-vectorwise-disabled`


### vectorwise

Scripts that convert queries to VectorWise specifics. They rely on the processing scripts for MonetDB.
