@echo off
call config.bat
REM ********************************************************************************
REM **Importando USO POP de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603202_USO_POP_PROPUESTO_
set lyrname=
call dosearch.bat

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln pop_uso %lyrname%
REM ** Eliminando campos innecesarios **

(echo ALTER TABLE %pgschema%.pop_uso DROP COLUMN IF EXISTS objectid;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop_uso DROP COLUMN IF EXISTS objectid_1;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop_uso DROP COLUMN IF EXISTS objectid_12;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop_uso DROP COLUMN IF EXISTS shape_area;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.pop_uso DROP COLUMN IF EXISTS shape_length;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

REM ** Agregando campos del geoSICOB **
(echo SELECT sicob_add_geoinfo_column('%pgschema%.pop_uso'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo SELECT sicob_update_geoinfo_column('%pgschema%.pop_uso'^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Eliminando polígonos con geometrías vacias **
(echo DELETE FROM %pgschema%.pop_uso WHERE sicob_sup IS NULL;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Corrigiendo errores del tipo “Self-intersection” **
(echo UPDATE %pgschema%.pop_uso SET the_geom = ST_CollectionExtract(st_makevalid(the_geom^^^), 3^^^) WHERE st_isvalid(the_geom^^^) = FALSE) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Corrigiendo formato de resolución de aprobación **
(echo UPDATE %pgschema%.pop_uso SET res_adm = replace( replace(res_adm, ' ', ''^^^) , '/', '-'^^^);)  | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ********************************************************************************
REM ** Creando capa de USO POP vigentes (por razones de performance del sistema) **
REM ********************************************************************************
(echo DROP TABLE IF EXISTS %pgschema%.pop_uso_vigente; CREATE TABLE %pgschema%.pop_uso_vigente AS SELECT * FROM %pgschema%.pop_uso WHERE trim(est^^^) = 'VIGENTE';) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando índices **
(echo ALTER TABLE %pgschema%.pop_uso_vigente ADD PRIMARY KEY (sicob_id^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pop_uso_vigente_idx_res_adm ON %pgschema%.pop_uso_vigente USING btree (res_adm COLLATE pg_catalog."default"^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% 
(echo CREATE INDEX pop_us_vigente_the_geom_geom_idx ON %pgschema%.pop_uso_vigente USING gist (the_geom public.gist_geometry_ops_2d^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% 
