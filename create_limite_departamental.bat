@echo off
call config.bat
REM ********************************************************************************
REM **Creando cobertura de limite departamental(ld) obtenidos de limite municipal(lm)**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f limite_departamental.sql