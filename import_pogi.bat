@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando PLAN OPERATIVO DE GESTION INTEGRAL (POGI) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_pogi%
set newlyrname=pogi
call import.bat

REM ** Adicionando indices **
(echo CREATE INDEX %newlyrname%_idx_res_adm ON %pgschema%.%newlyrname% USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %newlyrname%_idx_usos ON %pgschema%.%newlyrname% USING btree (usos_prop^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%