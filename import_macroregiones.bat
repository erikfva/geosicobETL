@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando MACRO REGIONES (MACROREG) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_macroreg%
set newlyrname=macroreg
call import.bat

REM ** Adicionando indices **
(echo CREATE INDEX %newlyrname%_idx_mac_reg ON %pgschema%.%newlyrname% USING btree (mac_reg^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%