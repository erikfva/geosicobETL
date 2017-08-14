@echo off
call config.bat
REM ********************************************************************************
REM **Importando Territorio Ind�gena Originario Campesino (TIOC) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603710_TCO_TIOC
set lyrname=
call dosearch.bat

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln tioc %lyrname%
REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS tipoobjeto) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.tioc DROP COLUMN IF EXISTS shape_leng) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Corrigiendo errores **
(echo UPDATE %pgschema%.tioc SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom^^^),3^^^)^^^) WHERE st_isvalid(the_geom^^^) = 'f') | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_add_geoinfo_column('%pgschema%.tioc'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.tioc'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando pol�gonos con geometr�as vacias **
(echo DELETE FROM %pgschema%.tioc WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_tioc.sql