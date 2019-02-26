#!/bin/bash

DIR=$(dirname "$(realpath "$0")")

# - add missing ')' for some "EXTRACT(... FROM (..." statements
#   and "TRUNC(..." function calls
# - disable 16 incomplete MLB queries
# - disable 3 queries on non-existing tables "pg_class" and
#   "#Tableau_2_2FCB0D6B-63F3-469A-9012-0F168B2ECE3F_10_Filter"
patch -p0 < $DIR/7-fix-queries_sql.patch

# - disable 122 queries demanding non-existing columns
#   + "CityMaxCapita_1"."City Pop"
#   + "Corporations_1"."company_name"
#   + "Food_1"."Calculation_1553038251886313475"
#   + "Food_1"."Calculation_1553038251895164934"
#   + "Food_1"."Calculation_1553038251895332871"
#   + "Food_1"."vendor"
#   + "Food_1"."volume(GB)"
#   + "HashTags_1"."Calculation_0360204212950443"
#   + "HashTags_1"."Calculation_1640205002654264"
#   + "HashTags_1"."Calculation_6520205001837946"
#   + "HashTags_1"."Calculation_7240304170015679"
#   + "HashTags_1"."Calculation_8180205002636660"
#   + "HashTags_1"."Calculation_8730311124516700"
#   + "HashTags_1"."Calculation_8760304164857491"
#   + "HashTags_1"."Calculation_8870205002708239"
#   + "Hatred_1"."State"
#   + "IGlocations1_1"."country"
#   + "IUBLibrary_1"."Calculation_649925789332455426"
#   + "MLB_37"."oi"
#   + "MLB_52"."PA"
#   + "MLB_57"."PA"
#   + "SalariesFrance_13"."APPELLATION"
#   + "SalariesFrance_1"."APPELLATION"
#   + "SalariesFrance_2"."REG_LIB"
#   + "SalariesFrance_4"."APPELLATION"
#   + "TableroSistemaPenal_1"."Año"
#   + "TableroSistemaPenal_1"."AÑO INGRESO"
#   + "TableroSistemaPenal_1"."COD_CORTE"
#   + "TableroSistemaPenal_1"."Grupo"
#   + "TableroSistemaPenal_1"."MOT_TERMINO"
#   + "TableroSistemaPenal_4"."FECHA"
#   + "TableroSistemaPenal_5"."FECHA"
#   + "TableroSistemaPenal_5"."MEDIDA"
#   + "TableroSistemaPenal_5"."TIP TRIB"
#   + "TableroSistemaPenal_6"."Forma Inicio"
#   + "TableroSistemaPenal_7"."Calculation_6750825005603169"
#   + "TableroSistemaPenal_8"."Calculation_7700228125057489"
#   + "TrainsUK2_2"."TOC"
#   + "Wins_1"."tTRK3"
#   + "YaleLanguages_1"."BIB_SUPPRESS_IN_OPAC"
#   + "YaleLanguages_1"."Call No Group (copy)"
#   + "YaleLanguages_5"."BIB_CREATE_DATE"
#   + "YaleLanguages_5"."BIB_SUPPRESS_IN_OPAC"
sed -i \
	-e 's|^\([^\-].*"CityMaxCapita_1"\."City Pop"\)|--\1|' \
	-e 's|^\([^\-].*"Corporations_1"\."company_name"\)|--\1|' \
	-e 's|^\([^\-].*"Food_1"\."Calculation_1553038251886313475"\)|--\1|' \
	-e 's|^\([^\-].*"Food_1"\."Calculation_1553038251895164934"\)|--\1|' \
	-e 's|^\([^\-].*"Food_1"\."Calculation_1553038251895332871"\)|--\1|' \
	-e 's|^\([^\-].*"Food_1"\."vendor"\)|--\1|' \
	-e 's|^\([^\-].*"Food_1"\."volume(GB)"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_0360204212950443"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_1640205002654264"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_6520205001837946"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_7240304170015679"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_8180205002636660"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_8730311124516700"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_8760304164857491"\)|--\1|' \
	-e 's|^\([^\-].*"HashTags_1"\."Calculation_8870205002708239"\)|--\1|' \
	-e 's|^\([^\-].*"Hatred_1"\."State"\)|--\1|' \
	-e 's|^\([^\-].*"IGlocations1_1"\."country"\)|--\1|' \
	-e 's|^\([^\-].*"IUBLibrary_1"\."Calculation_649925789332455426"\)|--\1|' \
	-e 's|^\([^\-].*"MLB_37"\."oi"\)|--\1|' \
	-e 's|^\([^\-].*"MLB_52"\."PA"\)|--\1|' \
	-e 's|^\([^\-].*"MLB_57"\."PA"\)|--\1|' \
	-e 's|^\([^\-].*"SalariesFrance_13"\."APPELLATION"\)|--\1|' \
	-e 's|^\([^\-].*"SalariesFrance_1"\."APPELLATION"\)|--\1|' \
	-e 's|^\([^\-].*"SalariesFrance_2"\."REG_LIB"\)|--\1|' \
	-e 's|^\([^\-].*"SalariesFrance_4"\."APPELLATION"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_1"\."Año"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_1"\."AÑO INGRESO"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_1"\."COD_CORTE"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_1"\."Grupo"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_1"\."MOT_TERMINO"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_4"\."FECHA"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_5"\."FECHA"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_5"\."MEDIDA"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_5"\."TIP TRIB"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_6"\."Forma Inicio"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_7"\."Calculation_6750825005603169"\)|--\1|' \
	-e 's|^\([^\-].*"TableroSistemaPenal_8"\."Calculation_7700228125057489"\)|--\1|' \
	-e 's|^\([^\-].*"TrainsUK2_2"\."TOC"\)|--\1|' \
	-e 's|^\([^\-].*"Wins_1"\."tTRK3"\)|--\1|' \
	-e 's|^\([^\-].*"YaleLanguages_1"\."BIB_SUPPRESS_IN_OPAC"\)|--\1|' \
	-e 's|^\([^\-].*"YaleLanguages_1"\."Call No Group (copy)"\)|--\1|' \
	-e 's|^\([^\-].*"YaleLanguages_5"\."BIB_CREATE_DATE"\)|--\1|' \
	-e 's|^\([^\-].*"YaleLanguages_5"\."BIB_SUPPRESS_IN_OPAC"\)|--\1|' \
	*/queries.sql
