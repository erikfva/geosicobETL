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
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln %newlyrname% -sql "%sql% FROM \"%lyrname%\""

REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_geomidx ON %pgschema%.%newlyrname% USING gist (%pggeom% public.gist_geometry_ops_2d);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
