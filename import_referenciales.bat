@echo off
call config.bat
REM ********************************************************************************
REM **Importando predios referenciales generados de diferentes capas de la UMIG**
REM ********************************************************************************

set fsource=C:\geosicob\geodatabaseSQL\referenciales.backup
pg_restore -h %pghost% -p %pgport% -U %pguser% -d "%pgdb%" -c -x -O -v "%fsource%" 

set fsource=C:\geosicob\geodatabaseSQL\predios_referenciales.backup
pg_restore -h %pghost% -p %pgport% -U %pguser% -d "%pgdb%" -c -x -O -v "%fsource%" 

REM ** GENERANDO LA COBERTURA DE "predios_referenciales" (opcional)
REM psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_referenciales.sql

