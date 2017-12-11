@echo off
call config.bat
REM ********************************************************************************
REM **Importando Predios Titulados del INRA de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603711_PREDIOS_TITULADOS_Z19_
set lyrname=
call dosearch.bat
set Zona19=%lyrname%

set lyrsearch=F0603711_PREDIOS_TITULADOS_Z20_
set lyrname=
call dosearch.bat
set Zona20=%lyrname%

set lyrsearch=F0603711_PREDIOS_TITULADOS_Z21_
set lyrname=
call dosearch.bat
set Zona21=%lyrname%

set lyrname=parcelas_tituladas
set pgschema=temp

set sql=SELECT num_doc AS titulo, fec_tit AS fecha_titulo, nom_pre AS predio, nom_tit AS propietario, clasifi AS tipo_propiedad, sup_cc, sup_pre AS sup_predio, clase_tit as clasetitul, califi as calificaci, (nom_pre+nom_tit) AS infopredio
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln %lyrname% -sql "%sql% FROM %Zona21%"
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln %lyrname% -sql "%sql% FROM %Zona20%"
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln %lyrname% -sql "%sql% FROM %Zona19%"

REM ** Adicionando índice de infopredio**
(echo CREATE INDEX %lyrname%_idx_infopredio ON %pgschema%.%lyrname% USING btree (infopredio^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

REM ** Ejecutando archivo de script SQL
psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_titulados.sql