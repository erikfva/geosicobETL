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
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_cod_srm ON %pgschema%.%newlyrname% USING btree (cod_srm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_nom_srm ON %pgschema%.%newlyrname% USING btree (nom_srm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%