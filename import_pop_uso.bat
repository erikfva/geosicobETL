@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando USO POP de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_uso_pop%
set newlyrname=pop_uso
call import.bat

REM ********************************************************************************
REM ** Creando capa de USO POP vigentes (por razones de performance del sistema) **
REM ********************************************************************************
(echo DROP TABLE IF EXISTS %pgschema%.pop_uso_vigente; CREATE TABLE %pgschema%.pop_uso_vigente AS SELECT * FROM %pgschema%.pop_uso WHERE trim(est_der^^^) = 'VIGENTE';) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando �ndices **
(echo ALTER TABLE %pgschema%.pop_uso_vigente ADD PRIMARY KEY (sicob_id^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX pop_uso_vigente_idx_res_adm ON %pgschema%.pop_uso_vigente USING btree (res_adm COLLATE pg_catalog."default"^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% 
(echo CREATE INDEX pop_us_vigente_the_geom_geom_idx ON %pgschema%.pop_uso_vigente USING gist (the_geom public.gist_geometry_ops_2d^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% 
