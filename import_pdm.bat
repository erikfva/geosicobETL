@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Plan de Desmonte (PDM) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_pdm%
set newlyrname=pdm
REM echo lyrname
call import.bat

REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "CREATE INDEX pdm_idx_res_adm ON %pgschema%.pdm USING btree (res_adm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pdm_idx_nom_pre ON %pgschema%.pdm USING btree (raz_soc);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pdm_idx_nom_pro ON %pgschema%.pdm USING btree (nom_pro);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pdm_idx_tip_pdm ON %pgschema%.pdm USING btree (tip_pdm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%