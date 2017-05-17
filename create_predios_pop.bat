@echo off
call config.bat
REM ********************************************************************************
REM **Creando cobertura de predios obtenidos de los POP**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_pop.sql