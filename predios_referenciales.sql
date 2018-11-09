-->2.	GENERANDO LOS POLIGONOS DE PREDIOS REFERENCIALES AGRUPADOS POR NOMBRE DE PROPIEDAD+PROPIETARIO
DROP TABLE IF EXISTS coberturas.predios_referenciales;
create table coberturas.predios_referenciales as
SELECT nompred as predio, beneficiar as propietario, min(source) as source, sum(sicob_sup) as sicob_sup , count(sicob_id) as parcelas, ST_Multi(ST_CollectionExtract(st_collect(st_makevalid(the_geom)),3)) as the_geom
FROM 
	coberturas.predios_proceso_geosicob_geo_201607
GROUP BY nompred || beneficiar, nompred, beneficiar, source;
--T : 3:44 min

-->** Adicionando �ndices **
ALTER TABLE coberturas.predios_referenciales  ADD COLUMN tsv tsvector;
UPDATE coberturas.predios_referenciales SET tsv = setweight(to_tsvector(predio), 'A') || setweight(to_tsvector(coalesce(propietario,'')), 'D');
CREATE INDEX predios_referenciales_tsv_idx ON coberturas.predios_referenciales USING gin(tsv);
CREATE INDEX predios_referenciales_the_geom_idx ON coberturas.predios_referenciales
  USING gist (the_geom public.gist_geometry_ops_2d);
--T 36s.
  
-->Agregando campos del geoSICOB
SELECT sicob_create_id_column('coberturas.predios_referenciales');
--T:54s.

--3.	CREANDO EL DETALLE DE LOS ELEMENTOS CON ERRORES (BORDES SOBREPUESTOS)
DROP TABLE IF EXISTS temp.predios_referenciales_to_fix;
create table temp.predios_referenciales_to_fix as
select sicob_id, predio, propietario, false as fixed
from coberturas.predios_referenciales
where st_isvalid(the_geom) = 'f';

--4.	CORRIGIENDO LAS GEOMETRIAS CON BORDES SOBREPUESTOS
update coberturas.predios_referenciales a
set the_geom =  b.the_geom
FROM
(  select sicob_id, st_union(the_geom) as the_geom from
  (select x.sicob_id, (st_dump(x.the_geom)).geom as the_geom from coberturas.predios_referenciales x inner join temp.predios_referenciales_to_fix y on (x.sicob_id = y.sicob_id) ) c
  group by sicob_id
) b
where a.sicob_id = b.sicob_id
--T: 1:27 min

--5.	VERIFICANDO QUE TODAS LAS GEOMETRIAS SEAN VALIDAS
--Repetir el punto 3, y despu�s verificar que no existan registros en la tabla de errores.
--select * from temp.predios_referenciales_to_fix;

--6.	ASIGNANDO LOS IDPREDIOS EN LA TABLA DE PARCELAS
UPDATE coberturas.predios_proceso_geosicob_geo_201607 a
SET idpredio = NULL;

CREATE INDEX parcelas_referenciales_idx_idpredio ON coberturas.predios_proceso_geosicob_geo_201607  USING btree (idpredio);

UPDATE coberturas.predios_proceso_geosicob_geo_201607 a
SET idpredio = (
SELECT b.sicob_id as id_b
from 
coberturas.predios_referenciales b 
WHERE a.nompred = b.predio AND ST_Intersects(a.the_geom , b.the_geom) AND NOT ST_Touches(a.the_geom , b.the_geom) limit 1 )
where
idpredio is null
--T: 1hora 5 min !!
--TODO: Crear una llave en la capa predios_proceso_geosicob_geo_201607 con el nombrepredio+nombreparcela 
-- que sirva como referencia para la asignacion y evitar la asignacion por analisis espacial.

--> Verificando que no hay errores en la asignaci�n de idpredios:
/*
-->a)	Que no existan pol�gonos sin asignar:
SELECT * FROM coberturas.predios_proceso_geosicob_geo_201607 WHERE idpredio IS NULL limit 1;

-->b)	Que el nombre de predio asignado sea el mismo de la parcela:
SELECT a.sicob_id, a.predio,b.sicob_id as id_b, b.nompred
from coberturas.predios_referenciales a INNER JOIN
  coberturas.predios_proceso_geosicob_geo_201607 b 
  ON (a.sicob_id = b.idpredio AND a.predio <> b.nompred) limit 1;
*/




