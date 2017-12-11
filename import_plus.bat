@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan de Uso de Suelo (PLUS) de las coberturas de la geodatabase UMIG ABT**
REM ********************************************************************************

%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln plus_scz F0603704_PLUS_SANTA_CRUZ 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln plus_ben F0603704_PLUS_BENI 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln plus_pdo F0603729_PLUS_PANDO_A2016 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln plus_chq F0603704_PLUS_CHUQUISACA 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln plus_tja F0603704_PLUS_TARIJA 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln plus_pts F0603726_PLUS_POTOSI_A2016 

REM ********************************************************************************
REM **Creando cobertura de PLUS de Bolivia**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f plus_bolivia.sql

REM ** Eliminando las coberturas de plus individuales

(echo DROP TABLE IF EXISTS %pgschema%.plus_pts;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo DROP TABLE IF EXISTS %pgschema%.plus_tja;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo DROP TABLE IF EXISTS %pgschema%.plus_pdo;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo DROP TABLE IF EXISTS %pgschema%.plus_ben;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo DROP TABLE IF EXISTS %pgschema%.plus_scz;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo DROP TABLE IF EXISTS %pgschema%.plus_chq;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%