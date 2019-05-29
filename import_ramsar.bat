@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando SITIOS RAMSAR (RAMSAR) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_ramsar%
set newlyrname=ramsar
call import.bat

REM ** Adicionando indices **
(echo CREATE INDEX %newlyrname%_idx_cod_srm ON %pgschema%.%newlyrname% USING btree (cod_srm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %newlyrname%_idx_nom_srm ON %pgschema%.%newlyrname% USING btree (nom_srm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%