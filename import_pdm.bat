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
(echo CREATE INDEX pdm_idx_res_adm ON %pgschema%.pdm USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_nom_pre ON %pgschema%.pdm USING btree (raz_soc^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_nom_pro ON %pgschema%.pdm USING btree (nom_pro^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_tip_pdm ON %pgschema%.pdm USING btree (tip_pdm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%