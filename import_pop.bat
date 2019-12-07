@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Plan de Orenamiento Predial (POP) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_pop%
set newlyrname=pop
call import.bat

REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "CREATE INDEX pop_idx_res_adm ON %pgschema%.pop USING btree (res_adm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pop_idx_est ON %pgschema%.pop USING btree (est_der);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
REM ********************************************************************************
REM **Creando capa de POP vigentes (por razones de performance del sistema)**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -c "DROP TABLE IF EXISTS %pgschema%.pop_vigente; CREATE TABLE %pgschema%.pop_vigente AS SELECT * FROM %pgschema%.pop WHERE trim(est_der) = 'VIGENTE';" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
REM ** Adicionando �ndices **
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.pop_vigente ADD PRIMARY KEY (gv_id);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pop_vigente_idx_res_adm ON %pgschema%.pop_vigente USING btree (res_adm COLLATE pg_catalog.default);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX pop_vigente_the_geom_geom_idx ON %pgschema%.pop_vigente USING gist (the_geom public.gist_geometry_ops_2d);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
