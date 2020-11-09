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
