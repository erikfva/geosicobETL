@echo off
call config.bat
REM ********************************************************************************
REM **Importando desmontes inscritos en el programa de restitución de la ley 337 de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=D0603402_DESMONTES_INSCRITOS
set lyrname=
call dosearch.bat

if "%lyrname%"=="" ( GOTO EOF )

set newlyrname=d337
call import.bat

REM ** Adicionando indice**
(echo CREATE INDEX %newlyrname%_idx_codigo ON %pgschema%.%newlyrname% USING btree (codigo^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

:EOF