@echo off
call config.bat
REM ********************************************************************************
REM **Importando Predios Titulados del INRA de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603711_PREDIOS_TITULADOS_Z19_
set lyrname=
call dosearch.bat
set Zona19=%lyrname%

set lyrsearch=F0603711_PREDIOS_TITULADOS_Z20_
set lyrname=
call dosearch.bat
set Zona20=%lyrname%

set lyrsearch=F0603711_PREDIOS_TITULADOS_Z21_
set lyrname=
call dosearch.bat
set Zona21=%lyrname%

set lyrname=parcelas_tituladas

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln %lyrname% %Zona19%
%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln %lyrname% %Zona20%
%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln %lyrname% %Zona21%

REM ** Eliminando campos innecesarios **
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS objectid) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS objectid_1) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS objectid_12) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS tipoobjeto) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS shape_area) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS shape_length) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% DROP COLUMN IF EXISTS shape_leng) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

REM ** Corrigiendo errores **
(echo UPDATE %pgschema%.%lyrname% SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom^^^),3^^^)^^^) WHERE st_isvalid(the_geom^^^) = 'f') | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

REM ** Renombrando campos para su uso en el geoSICOB **
(echo ALTER TABLE %pgschema%.%lyrname% RENAME COLUMN numerodocu TO titulo) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% RENAME COLUMN parcela TO predio) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% RENAME COLUMN nombreplan TO propietario) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% RENAME COLUMN fechadocum TO fecha_titulo) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% RENAME COLUMN clasificac TO tipo_propiedad) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo ALTER TABLE %pgschema%.%lyrname% RENAME COLUMN superficie TO sup_predio) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
REM ** Adicionando índices **
(echo CREATE INDEX %lyrname%_idx_idpredio ON %pgschema%.%lyrname% USING btree (idpredio^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %lyrname%_idx_titulo ON %pgschema%.%lyrname% USING btree (titulo^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %lyrname%_idx_predio ON %pgschema%.%lyrname% USING btree (predio^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %lyrname%_idx_propietario ON %pgschema%.%lyrname% USING btree (propietario^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %lyrname%_idx_tipo_propiedad ON %pgschema%.%lyrname% USING btree (tipo_propiedad^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%

psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb% -f predios_titulados.sql

REM (echo CREATE OR REPLACE VIEW coberturas.predios_titulados AS SELECT c.sicob_id, c.numerodocu AS titulo, c.parcela AS predio, c.nombreplan AS propietario, c.fechadocum AS fecha_titulo, c.clasificac AS tipo_propiedad, c.sup_cc AS sup_predio, NULL::text AS resol_pop, NULL::timestamp with time zone AS fec_resol_pop, c.the_geom FROM coberturas.predios_titulados_geo_inra c;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%