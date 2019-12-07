@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Plan de Uso de Suelo (PLUS) de las coberturas de la geodatabase UMIG ABT**
REM ********************************************************************************

%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_scz %lyr_plus_scz% 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_ben %lyr_plus_ben% 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_pdo %lyr_plus_pan% 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_chq %lyr_plus_chq% 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_tja %lyr_plus_tja% 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_pts %lyr_plus_pot% 
%PATH_OGR2OGR%ogr2ogr -f "PostgreSQL" PG:"host=%pghost% user=%pguser% password=%pgpass% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" %PATH_GDB% -lco GEOMETRY_NAME=%pggeom% -lco FID=gv_id -overwrite -progress --config PG_USE_COPY YES -nln plus_cbba %lyr_plus_cbba%
REM ********************************************************************************
REM **Creando cobertura de PLUS de Bolivia**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -f plus_bolivia.sql postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%

REM ** Eliminando las coberturas de plus individuales

psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_pts;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_tja;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_pdo;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_ben;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_scz;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_chq;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.plus_cbba;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%