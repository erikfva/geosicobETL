@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando rredios referenciales mediante restauracion de archivos .backup **
REM ********************************************************************************

set predios_proceso=E:\geosicobdb\predios_proceso_geosicob_geo_201607.backup
set predios_referenciales=E:\geosicobdb\predios_referenciales.backup

pg_restore -h %pghost% -p %pgport% -U %pguser% -d "%pgdb%" -c -x -O -v "%predios_proceso%"
pg_restore -h %pghost% -p %pgport% -U %pguser% -d "%pgdb%" -c -x -O -v "%predios_referenciales%"
psql -h %pghost% -p %pgport% -c "ALTER TABLE coberturas.predios_proceso_geosicob_geo_201607 RENAME COLUMN sicob_id TO gv_id; ALTER TABLE coberturas.predios_proceso_geosicob_geo_201607 RENAME COLUMN sicob_sup TO gv_sup;ALTER TABLE coberturas.predios_proceso_geosicob_geo_201607 RENAME COLUMN sicob_utm TO gv_utm;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "ALTER TABLE coberturas.predios_referenciales RENAME COLUMN sicob_id TO gv_id; ALTER TABLE coberturas.predios_referenciales RENAME COLUMN sicob_sup TO gv_sup;" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%