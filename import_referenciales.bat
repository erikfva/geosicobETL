@echo off
call config.bat
REM ********************************************************************************
REM **Importando predios referenciales generados de diferentes capas de la UMIG**
REM ********************************************************************************

set fsource=e:\geosicobdb\referenciales.backup
pg_restore -h %pghost% -p %pgport% -U %pguser% -d "%pgdb%" -c -x -O -v "%fsource%" 
psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f parcelas_referenciales.sql

set fsource=e:\geosicobdb\predios_referenciales.backup
pg_restore -h %pghost% -p %pgport% -U %pguser% -d "%pgdb%" -c -x -O -v "%fsource%" 

REM ** GENERANDO LA COBERTURA DE "predios_referenciales" (opcional)
REM psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_referenciales.sql

