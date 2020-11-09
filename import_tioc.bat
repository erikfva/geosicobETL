@echo off
call config.bat
REM ********************************************************************************
REM **Importando Territorio Ind�gena Originario Campesino (TIOC) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

REM set lyrsearch=F0603710_TCO_TIOC
REM set lyrname=
REM call dosearch.bat
REM set newlyrname=tioc
REM call import.bat

REM psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_tioc.sql

echo drop table if exists coberturas.predios_tioc; ^
create table coberturas.predios_tioc as ^
select * from coberturas.predios_titulados where titulo LIKE '%%TIOC%%' or titulo LIKE '%%TCO%%'; ^
 > create_tioc.sql
psql -h %pghost% -p %pgport% -f "create_tioc.sql"  postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%