-->Creando cobertura de predios titulados agrupando las parcelas por idpredio
DROP TABLE IF EXISTS coberturas.predios_titulados;
create table coberturas.predios_titulados as
SELECT idpredio,predio, propietario, string_agg(t.titulo , ',') as titulo, string_agg(t.fecha_titulo , ',') as fecha_titulo, string_agg(t.clasetitul , ',') as clasetitul, min(t.calificaci) as calificaci, min(t.tipo_propiedad) as tipo_propiedad, sum(sup_predio) as sup_predio, sum(parcelas) as parcelas, ST_CollectionExtract(st_collect(the_geom),3) as the_geom
FROM (
	SELECT idpredio,predio, propietario, titulo, to_char(fecha_titulo,'DD/MM/YYYY') AS fecha_titulo, clasetitul, calificaci, tipo_propiedad, max(sup_predio) as sup_predio, count(idpredio) as parcelas, st_collect(the_geom) as the_geom
	FROM coberturas.parcelas_tituladas t
	GROUP BY idpredio,predio,propietario,titulo, fecha_titulo, clasetitul, calificaci, tipo_propiedad
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
-->Agregando campos del geoSICOB
SELECT sicob_create_id_column('coberturas.predios_titulados');

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
where a.sicob_id = b.sicob_id
