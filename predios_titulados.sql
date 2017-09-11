--> Creando cobertura de parcelas_tituladas
DROP TABLE IF EXISTS coberturas.parcelas_tituladas;
create table coberturas.parcelas_tituladas as
SELECT min(a.sicob_id) OVER w AS idpredio, count(a.infopredio) OVER w AS parcelas,
a.* 
FROM temp.parcelas_tituladas a
 WINDOW w AS (PARTITION BY a.infopredio);

-->Eliminando archivo temporal
DROP TABLE temp.parcelas_tituladas CASCADE;

/** Corrigiendo errores **/
UPDATE coberturas.parcelas_tituladas SET the_geom = ST_Multi(ST_CollectionExtract(st_makevalid(the_geom),3)) WHERE st_isvalid(the_geom) = 'f';

-->** Adicionando índices **
DROP INDEX IF EXISTS  coberturas.parcelas_tituladas_idx_idpredio;
CREATE INDEX parcelas_tituladas_idx_idpredio ON coberturas.parcelas_tituladas USING btree (idpredio);
DROP INDEX IF EXISTS coberturas.parcelas_tituladas_idx_titulo;
CREATE INDEX parcelas_tituladas_idx_titulo ON coberturas.parcelas_tituladas USING btree (titulo);
DROP INDEX IF EXISTS  coberturas.parcelas_tituladas_idx_predio;
CREATE INDEX parcelas_tituladas_idx_predio ON coberturas.parcelas_tituladas USING btree (predio);
DROP INDEX IF EXISTS  coberturas.parcelas_tituladas_idx_propietario;
CREATE INDEX parcelas_tituladas_idx_propietario ON coberturas.parcelas_tituladas USING btree (propietario);
DROP INDEX IF EXISTS  coberturas.parcelas_tituladas_idx_tipo_propiedad;
CREATE INDEX parcelas_tituladas_idx_tipo_propiedad ON coberturas.parcelas_tituladas USING btree (tipo_propiedad);
DROP INDEX IF EXISTS  coberturas.parcelas_tituladas_geom_idx;
CREATE INDEX parcelas_tituladas_geom_idx ON coberturas.parcelas_tituladas
  USING gist (the_geom public.gist_geometry_ops_2d);
ALTER TABLE coberturas.parcelas_tituladas DROP CONSTRAINT IF EXISTS parcelas_tituladas_pkey;
ALTER TABLE coberturas.parcelas_tituladas ADD PRIMARY KEY (sicob_id);

-->Creando cobertura de predios titulados agrupando las parcelas por idpredio
DROP TABLE IF EXISTS coberturas.predios_titulados;
create table coberturas.predios_titulados as
SELECT row_number() over() AS sicob_id, idpredio,predio, propietario, string_agg(titulo , ',') as titulo, 
	string_agg(fecha_titulo , ',') as fecha_titulo, string_agg(clasetitul , ',') as clasetitul, min(calificaci) as calificaci, 
	min(tipo_propiedad) as tipo_propiedad, max(sup_predio) as sup_predio, max(parcelas) as parcelas,
	(SELECT ST_Multi(ST_CollectionExtract(st_collect(the_geom),3)) as the_geom 
		FROM coberturas.parcelas_tituladas u WHERE u.idpredio =t.idpredio
	) AS the_geom
FROM (
	SELECT DISTINCT ON (idpredio,titulo)
	idpredio ,predio, propietario, titulo, to_char(fecha_titulo,'DD/MM/YYYY') AS fecha_titulo, clasetitul, calificaci, tipo_propiedad, sup_predio,parcelas
	FROM coberturas.parcelas_tituladas 
	order by idpredio,titulo
) t
GROUP BY t.idpredio,t.predio,t.propietario;

-->** Adicionando índices **
CREATE INDEX predios_titulados_idx_idpredio ON coberturas.predios_titulados USING btree (idpredio);
CREATE INDEX predios_titulados_idx_titulo ON coberturas.predios_titulados USING btree (titulo);
CREATE INDEX predios_titulados_idx_predio ON coberturas.predios_titulados USING btree (predio);
CREATE INDEX predios_titulados_idx_propietario ON coberturas.predios_titulados USING btree (propietario);
CREATE INDEX predios_titulados_idx_tipo_propiedad ON coberturas.predios_titulados USING btree (tipo_propiedad);
CREATE INDEX predios_titulados_the_geom_geom_idx ON coberturas.predios_titulados
  USING gist (the_geom public.gist_geometry_ops_2d);
ALTER TABLE coberturas.predios_titulados ADD PRIMARY KEY (sicob_id);

-->CREANDO EL DETALLE DE LOS ELEMENTOS CON ERRORES (BORDES SOBREPUESTOS)
DROP TABLE IF EXISTS temp.predios_titulados_to_fix;
create table temp.predios_titulados_to_fix as
select sicob_id, idpredio, predio, propietario
from coberturas.predios_titulados
where st_isvalid(the_geom) = 'f';

-->CORRIGIENDO LAS GEOMETRIAS CON BORDES SOBREPUESTOS
update coberturas.predios_titulados a
set the_geom =  b.the_geom
FROM
(  select sicob_id, st_union(st_makevalid(the_geom)) as the_geom from
  (select x.sicob_id, (st_dump(x.the_geom)).geom as the_geom from coberturas.predios_titulados x inner join temp.predios_titulados_to_fix y on (x.sicob_id = y.sicob_id) ) c
  group by sicob_id
) b
where a.sicob_id = b.sicob_id;

--> Eliminando archivo temporal
DROP TABLE IF EXISTS temp.predios_titulados_to_fix CASCADE;
