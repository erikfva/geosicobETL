@echo off
call config.bat
REM ********************************************************************************
REM **Importando Limites Municipales de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603703_LIMITES_MUNICIPALES_
set lyrname=
call dosearch.bat
set newlyrname=lm
call import.bat
REM ** Creando TABLA de limites_municipales **
(echo DROP TABLE IF EXISTS %pgschema%.limites_municipales; CREATE TABLE %pgschema%.limites_municipales AS SELECT c.sicob_id, c.nom_mun, c.nom_prov, c.nom_dep, c.the_geom FROM coberturas.lm c;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando índices **
(echo ALTER TABLE %pgschema%.limites_municipales ADD PRIMARY KEY (sicob_id^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX limites_municipales_geomidx ON %pgschema%.limites_municipales USING gist (the_geom public.gist_geometry_ops_2d^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%