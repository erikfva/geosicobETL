-->1.	CREANDO INDICE EN PARCELAS REFERENCIALES
ALTER TABLE coberturas.predios_proceso_geosicob_geo_201607  ADD COLUMN tsv tsvector;
CREATE INDEX tsv_idx ON coberturas.predios_proceso_geosicob_geo_201607  USING gin(tsv);
UPDATE coberturas.predios_proceso_geosicob_geo_201607  SET tsv = setweight(to_tsvector(nompred), 'A') || setweight(to_tsvector(coalesce(beneficiar,'')), 'D');
DELETE from coberturas.predios_proceso_geosicob_geo_201607  
where 
tsv @@ to_tsquery('TIERRA & FISCAL');
--T: 2min

-->Agregando campos del geoSICOB
SELECT sicob_add_geoinfo_column('coberturas.predios_proceso_geosicob_geo_201607');
SELECT sicob_update_geoinfo_column('coberturas.predios_proceso_geosicob_geo_201607');
--T: 4:30min
