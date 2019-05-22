@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando PLAN DE GESTION INTEGRAL DE BOSQUES Y TIERRA (PGIBT) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_pgibt%
set newlyrname=pgibt
call import.bat

REM ** Adicionando indices **
(echo CREATE INDEX %newlyrname%_idx_res_adm ON %pgschema%.%newlyrname% USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %newlyrname%_idx_est ON %pgschema%.%newlyrname% USING btree (est_der^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%