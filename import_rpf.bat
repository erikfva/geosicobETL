@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando REGISTRO DE PLANTACIONES FORESTALES (RPF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_rpf%
set newlyrname=rpf
call import.bat

REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_res_adm ON %pgschema%.%newlyrname% USING btree (res_adm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_est ON %pgschema%.%newlyrname% USING btree (est_der);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%