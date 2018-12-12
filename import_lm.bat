@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Limites Municipales de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_lm%
set newlyrname=lm

REM ** Creando TABLA de limites_municipales **

set sql=SELECT mun as nom_mun, prov as nom_prov, dep as nom_dep
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln %newlyrname% -sql "%sql% FROM \"%lyrname%\""

REM ** Adicionando indices **
REM (echo ALTER TABLE %pgschema%.%newlyrname% ADD PRIMARY KEY (sicob_id^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %newlyrname%_geomidx ON %pgschema%.%newlyrname% USING gist (the_geom public.gist_geometry_ops_2d^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%