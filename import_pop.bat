@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan de Orenamiento Predial (POP) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603202_POP_
set lyrname=
call dosearch.bat
set newlyrname=pop
call import.bat

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
