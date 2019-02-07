-->Creando cobertura de limite departamental
DROP TABLE IF EXISTS coberturas.ld;
CREATE TABLE coberturas.ld AS
WITH mun as (
SELECT sicob_id, 
	CASE 
		WHEN nom_dep = 'LAGO' THEN 'LA PAZ'
		WHEN nom_dep = 'SALAR' THEN 'ORURO'
	ELSE
		nom_dep
	END as nom_dep,
	the_geom
	FROM coberturas.lm
)
SELECT row_number() over ()  as sicob_id, st_union(the_geom) as the_geom, nom_dep
            FROM mun
            group by nom_dep;
-->Adicionando indices
CREATE INDEX ld_idx_nom_dep ON coberturas.ld
  USING btree (nom_dep COLLATE pg_catalog."default");
CREATE INDEX ld_the_geom_geom_idx ON coberturas.ld
  USING gist (the_geom public.gist_geometry_ops_2d);
-->Agregando campos del geoSICOB
SELECT sicob_create_id_column('coberturas.ld');
SELECT sicob_add_geoinfo_column('coberturas.ld');
SELECT sicob_update_geoinfo_column('coberturas.ld');