-->Creando cobertura de servidumbres ecologicas mediante "merge" de las capas
--> selpas, seltum y seltpfp.
DROP TABLE IF EXISTS coberturas.sel CASCADE;
CREATE TABLE coberturas.sel AS
SELECT * FROM coberturas.selpas
NATURAL FULL OUTER JOIN (SELECT * FROM coberturas.seltum) t2 
NATURAL FULL OUTER JOIN (SELECT * FROM coberturas.seltpfp) t3;
DROP TABLE IF EXISTS coberturas.selpas CASCADE;
DROP TABLE IF EXISTS coberturas.seltpfp CASCADE;
DROP TABLE IF EXISTS coberturas.seltum CASCADE;
-->Agregando campos del geoSICOB
SELECT sicob_create_id_column('coberturas.sel');
-->Adicionando indices
CREATE INDEX sel_the_geom_geom_idx ON coberturas.sel
  USING gist (the_geom public.gist_geometry_ops_2d);