@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando desmontes inscritos en el programa de restitución de la ley 337 de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_d337%

if "%lyrname%"=="" ( GOTO EOF )

set newlyrname=d337
call import.bat

REM ** Adicionando indice**
REM (echo CREATE INDEX %newlyrname%_idx_codigo ON %pgschema%.%newlyrname% USING btree (cod_pre^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_codigo ON %pgschema%.%newlyrname% USING btree (cod_pre);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%

:EOF