@echo off
call config.bat
REM ********************************************************************************
REM **Importando Desmontes Ilegales con Proceso Administrativo Sancionatorio (DPAS) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=PAS_DESMONTE_ILEGAL_
set lyrname=
call dosearch.bat

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln dpas %lyrname%
REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS tipoobjeto) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.dpas DROP COLUMN IF EXISTS shape_leng) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Corrigiendo errores **
(echo UPDATE %pgschema%.dpas SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom^^^),3^^^)^^^) WHERE st_isvalid(the_geom^^^) = 'f') | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_add_geoinfo_column('%pgschema%.dpas'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.dpas'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando polígonos con geometrías vacias **
(echo DELETE FROM %pgschema%.dpas WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%