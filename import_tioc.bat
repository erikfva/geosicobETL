@echo off
call config.bat
REM ********************************************************************************
REM **Importando Territorio Indígena Originario Campesino (TIOC) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603710_TCO_TIOC
set lyrname=
call dosearch.bat
set newlyrname=tioc
call import.bat

psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_tioc.sql