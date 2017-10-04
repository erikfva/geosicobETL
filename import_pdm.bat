@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan de Desmonte (PDM) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603206_PDM_
set lyrname=
call dosearch.bat

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -overwrite -progress --config PG_USE_COPY YES -nln pdm %lyrname%
REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.pdm DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pdm DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pdm DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pdm DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pdm DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Corrigiendo errores **
(echo UPDATE %pgschema%.pdm SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom^^^),3^^^)^^^) WHERE st_isvalid(the_geom^^^) = 'f') | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_create_id_column('%pgschema%.pdm'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_add_geoinfo_column('%pgschema%.pdm'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.pdm'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando pol�gonos con geometr�as vacias **
(echo DELETE FROM %pgschema%.pdm WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando �ndices **
(echo CREATE INDEX pdm_idx_res_adm ON coberturas.pdm USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_nom_pre ON coberturas.pdm USING btree (nom_pre^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_nom_pro ON coberturas.pdm USING btree (nom_pro^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pdm_idx_tip_pdm ON coberturas.pdm USING btree (tip_pdm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
