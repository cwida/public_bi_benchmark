#!/bin/bash

# fix "broken" tables.sql scripts

patch MulheresMil/tables.sql << EOF
--- MulheresMil/tables.sql	2018-08-04 15:53:04.000000000 +0200
+++ -	2018-09-11 21:22:19.576721797 +0200
@@ -1,5 +1,4 @@
-"Output format is unaligned." ,
-   "Field separator is "" ".CREATE TABLE "Dummy1"(
+CREATE TABLE "MulheresMil_1"(
    "Calculation_838513981443702785" varchar,
    "Calculation_838513981462429699" varchar,
    "Codigo Diploma/Certificado" varchar,
EOF

patch TableroSistemaPenal/tables.sql << EOF
--- TableroSistemaPenal/tables.sql	2018-08-04 15:53:04.000000000 +0200
+++ -	2018-09-11 21:22:19.630060335 +0200
@@ -118,7 +118,7 @@
    "Rechaza Prisión Preventiva (copia)" varchar,
    "SENTENCIA" double,
    "TIPO" smallint,
-   "TRIBUNAL" varchar,
+   "TRIBUNAL" varchar
 );
 CREATE TABLE "TableroSistemaPenal_6"(
    "AUDIENCIA" varchar,
EOF

