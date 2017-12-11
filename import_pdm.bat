@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan de Desmonte (PDM) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603206_PDM_
set lyrname=
call dosearch.bat
set newlyrname=pdm
echo lyrname
call import.bat

REM ** Adicionando indices **
(echo CREATE INDEX pdm_idx_res_adm ON %pgschema%.pdm USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_nom_pre ON %pgschema%.pdm USING btree (nom_pre^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_nom_pro ON %pgschema%.pdm USING btree (nom_pro^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_tip_pdm ON %pgschema%.pdm USING btree (tip_pdm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
