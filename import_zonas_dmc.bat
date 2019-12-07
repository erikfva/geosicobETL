@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando zonas de vida para el diametro minimo de corta DMC**
REM ********************************************************************************

set newlyrname=zonas_dmc
set PATH_SHP=J:\ABT 2019\zona_vida\zonas_dmc_single.shp

psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.%newlyrname%;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%

%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_SHP%" -lco GEOMETRY_NAME=%pggeom% -nlt MULTIPOLYGON -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln %newlyrname%
REM ** Eliminando campos innecesarios **
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS objectid" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS objectid_1" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS objectid_12" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS tipoobjeto" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS shape_area" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS shape_length" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS shape_leng" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
REM ** Corrigiendo errores **
psql -h %pghost% -p %pgport% -c "UPDATE %pgschema%.%newlyrname% SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom),3)) WHERE st_isvalid(the_geom) = 'f'" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
REM ** Agregando campos del geovision **
psql -h %pghost% -p %pgport% -c "SELECT gv_add_geoinfo_column('%pgschema%.%newlyrname%');" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "SELECT gv_update_geoinfo_column('%pgschema%.%newlyrname%');" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
REM ** Eliminando poligonos con geometrias vacias **
psql -h %pghost% -p %pgport% -c "DELETE FROM %pgschema%.%newlyrname% WHERE gv_sup IS NULL;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%