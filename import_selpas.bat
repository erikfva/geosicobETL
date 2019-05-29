@echo on
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando SERVIDUMBRES ECOLOGICAS (SEL) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_selpas%
set newlyrname=selpas
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln %newlyrname% %lyrname% -limit 1000
REM call import.bat
REM ** Adicionando la fuente de informacion **
(echo ALTER TABLE %pgschema%.%newlyrname% ADD COLUMN source TEXT DEFAULT '%lyrname%';) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%