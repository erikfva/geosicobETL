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

%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -lco FID=sicob_id -overwrite -progress --config PG_USE_COPY YES -nln predios_titulados_geo_inra %Zona19%
%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln predios_titulados_geo_inra %Zona20%
%PATH_OGR2OGR% -f "PostgreSQL" PG:"host=%pghost% user=%pguser% port=%pgport% dbname=%pgdb% ACTIVE_SCHEMA=%pgschema%" "%PATH_GDB%" -lco GEOMETRY_NAME=%pggeom% -append -progress --config PG_USE_COPY YES -nln predios_titulados_geo_inra %Zona21%
(echo CREATE OR REPLACE VIEW coberturas.predios_titulados AS SELECT c.sicob_id, c.numerodocu AS titulo, c.parcela AS predio, c.nombreplan AS propietario, c.fechadocum AS fecha_titulo, c.clasificac AS tipo_propiedad, c.sup_cc AS sup_predio, NULL::text AS resol_pop, NULL::timestamp with time zone AS fec_resol_pop, c.the_geom FROM coberturas.predios_titulados_geo_inra c;) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%