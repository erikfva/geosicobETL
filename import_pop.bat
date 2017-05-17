@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan de Orenamiento Predial (POP) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603202_POP_
set lyrname=
call dosearch.bat

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln pop %lyrname%
REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.pop DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_add_geoinfo_column('%pgschema%.pop'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.pop'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando polígonos con geometrías vacias **
(echo DELETE FROM %pgschema%.pop WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando índices **
(echo CREATE INDEX pop_idx_res_adm ON %pgschema%.pop USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pop_idx_est ON %pgschema%.pop USING btree (est^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ********************************************************************************
REM **Creando capa de POP vigentes (por razones de performance del sistema)**
REM ********************************************************************************
(echo DROP TABLE IF EXISTS %pgschema%.pop_vigente; CREATE TABLE %pgschema%.pop_vigente AS SELECT * FROM %pgschema%.pop WHERE trim(est^^^) = 'VIGENTE';)  | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando índices **
(echo ALTER TABLE %pgschema%.pop_vigente ADD PRIMARY KEY (sicob_id^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pop_vigente_idx_res_adm ON %pgschema%.pop_vigente USING btree (res_adm COLLATE pg_catalog."default"^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pop_vigente_the_geom_geom_idx ON %pgschema%.pop_vigente USING gist (the_geom public.gist_geometry_ops_2d^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
