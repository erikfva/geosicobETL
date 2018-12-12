@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Predios Titulados del INRA de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set Zona19=%lyr_tit_z19%
set Zona20=%lyr_tit_z20%
set Zona21=%lyr_tit_z21%

set lyrname=parcelas_tituladas
set pgschema=temp

set sql=SELECT num_doc AS titulo, fec_tit AS fecha_titulo, nom_pre AS predio, nom_tit AS propietario, clasifi AS tipo_propiedad, sup_cc, sup_pre AS sup_predio, (nom_pre+nom_tit) AS infopredio
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln %lyrname% -sql "%sql% FROM \"%Zona21%\""
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln %lyrname% -sql "%sql% FROM \"%Zona20%\""
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln %lyrname% -sql "%sql% FROM \"%Zona19%\""

REM ** Adicionando indice de infopredio**
(echo CREATE INDEX %lyrname%_idx_infopredio ON %pgschema%.%lyrname% USING btree (infopredio^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

REM ** Ejecutando archivo de script SQL
psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_titulados.sql