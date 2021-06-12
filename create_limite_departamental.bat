@echo off
call config.bat
REM ********************************************************************************
REM **Creando cobertura de limite departamental(ld) obtenidos de limite municipal(lm)**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -f "limite_departamental.sql"  postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%