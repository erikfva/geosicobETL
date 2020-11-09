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
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.pop_uso_vigente; CREATE TABLE %pgschema%.pop_uso_vigente AS SELECT * FROM %pgschema%.pop_uso WHERE trim(est_der) <> 'NO VIGENTE';" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.pop_uso_vigente ADD PRIMARY KEY (%fnPrefix%_id);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pop_uso_vigente_idx_res_adm ON %pgschema%.pop_uso_vigente USING btree (res_adm COLLATE pg_catalog.default);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pop_us_vigente_the_geom_geom_idx ON %pgschema%.pop_uso_vigente USING gist (the_geom public.gist_geometry_ops_2d);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
