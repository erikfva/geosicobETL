@echo off
call config.bat
REM ********************************************************************************
REM **Creando cobertura de predios obtenidos de los POP**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -f predios_pop.sql postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%