@echo off
call config.bat
REM ********************************************************************************
REM **Importando Capacidad Uso Mayor de la Tierra (CUMAT) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln cumat F0603715_CUMAT
REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.cumat DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.cumat DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.cumat DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.cumat DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.cumat DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_add_geoinfo_column('%pgschema%.cumat'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.cumat'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando polígonos con geometrías vacias **
(echo DELETE FROM %pgschema%.cumat WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%