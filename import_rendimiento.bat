@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Regiones Productivas para calculo de volumenes maximos**
REM ********************************************************************************

set newlyrname=zonas_productivas
set PATH_SHP=D:\shapes\ECOREGIONES_PDM.shp

%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_SHP%" -lco GEOMETRY_NAME=%pggeom% -nlt POLYGON -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln %newlyrname%
REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS tipoobjeto) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%newlyrname% DROP COLUMN IF EXISTS shape_leng) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Corrigiendo errores **
(echo UPDATE %pgschema%.%newlyrname% SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom^^^),3^^^)^^^) WHERE st_isvalid(the_geom^^^) = 'f') | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_add_geoinfo_column('%pgschema%.%newlyrname%'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.%newlyrname%'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando poligonos con geometrias vacias **
(echo DELETE FROM %pgschema%.%newlyrname% WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%