--> INF : Creación de capa de predios_tioc

-->1.	AGREGANDO INDICES EN LA COBERTURA DE PARCELAS PARA UNA RAPIDA REFERENCIA EN LAS CONSULTAS
CREATE INDEX tioc_idx_idpredio ON coberturas.tioc  USING btree (idpredio);
ALTER TABLE coberturas.tioc  ADD COLUMN tsv tsvector;
CREATE INDEX tioc_tsv_idx ON coberturas.tioc USING gin(tsv);
UPDATE coberturas.tioc SET tsv = to_tsvector(nomparcela);
--T: 1.4s

-->2.	GENERANDO LOS POLIGONOS DE TIOCS AGRUPADOS POR NOMBRE DE TIOC

DROP TABLE IF EXISTS coberturas.predios_tioc;
create table coberturas.predios_tioc as
SELECT idpredio, nomparcela as predio, nomparcela as propietario, sum(sup_cc) as sup_predio, count(sicob_id) as parcelas, sum(sicob_sup) as sicob_sup, ST_Multi(ST_CollectionExtract(st_collect(st_makevalid(the_geom)),3)) as the_geom
FROM 
	coberturas.tioc
GROUP BY idpredio, nomparcela;
--T: 1min 3s
-->** Adicionando índices **
CREATE INDEX predios_tioc_idx_idpredio ON coberturas. predios_tioc  USING btree (idpredio);
ALTER TABLE coberturas. predios_tioc  ADD COLUMN tsv tsvector;
CREATE INDEX predios_tioc_tsv_idx ON coberturas. predios_tioc USING gin(tsv);
UPDATE coberturas. predios_tioc SET tsv = to_tsvector(predio);
--T: 625ms
CREATE INDEX predios_tioc_the_geom_idx ON coberturas.predios_tioc  
  USING gist (the_geom public.gist_geometry_ops_2d);
-->Agregando campos del geoSICOB
SELECT sicob_create_id_column('coberturas.predios_tioc' );
--T: 15.187s

-->3.	VERIFICANDO QUE TODAS LOS POLIGONOS DE LA CAPA tioc HAYAN SIDO AGRUPADOS
/*
SELECT a.idpredio, b.idpredio
from coberturas.tioc a left join coberturas.predios_tioc b
on (a.idpredio = b.idpredio)
where b.idpredio IS NULL
T: 31ms
*/

-->4.	CREANDO EL DETALLE DE LOS ELEMENTOS CON ERRORES (BORDES SOBREPUESTOS)

DROP TABLE IF EXISTS temp.predios_tioc_to_fix;
create table temp.predios_tioc_to_fix as
select sicob_id, predio
from coberturas.predios_tioc
where st_isvalid(the_geom) = 'f';
--T: 16s total 146 filas

-->5.	CORRIGIENDO LAS GEOMETRIAS CON BORDES SOBREPUESTOS

update coberturas.predios_tioc a
set the_geom =  b.the_geom
FROM
(  select sicob_id, st_union(the_geom) as the_geom from
  (select x.sicob_id, (st_dump(x.the_geom)).geom as the_geom from coberturas.predios_tioc x inner join temp.predios_tioc_to_fix y on (x.sicob_id = y.sicob_id) ) c
  group by sicob_id
) b
where a.sicob_id = b.sicob_id
--T: 15.58s

-->6.	VERIFICANDO QUE TODOS HAYAN SIDO CORREGIDOS
/*
Primero volver a ejecutar el punto 4, y luego:

select * from temp.predios_tioc_to_fix
(no deben existir polígonos)
*/