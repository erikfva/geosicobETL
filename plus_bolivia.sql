-->Creando cobertura de PLUS de Bolivia
DROP TABLE IF EXISTS coberturas.plus;
CREATE TABLE coberturas.plus AS
SELECT 
  coberturas.plus_scz.dgntext as codigo,
  coberturas.plus_scz.categoria,
  coberturas.plus_scz.subcat as subcategoria,
  'F0603704_PLUS_SANTA_CRUZ' as source,
  coberturas.plus_scz.the_geom
FROM
  coberturas.plus_scz
WHERE 
trim(COALESCE(coberturas.plus_scz.categoria,'')) <> '' 
OR trim(COALESCE(coberturas.plus_scz.subcat,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_ben.plus as codigo,
  coberturas.plus_ben.categoria,
  coberturas.plus_ben.categoria as subcategoria,
  'F0603704_PLUS_BENI' AS source,
  coberturas.plus_ben.the_geom
FROM
  coberturas.plus_ben
WHERE
 trim(COALESCE(coberturas.plus_ben.categoria,'')) <> '' 
UNION ALL
SELECT 
  coberturas.plus_pdo.codigo,
  coberturas.plus_pdo.usos as categoria,
  coberturas.plus_pdo.vegetacion as subcategoria,
  'F0603729_PLUS_PANDO_A2016' as source,
  coberturas.plus_pdo.the_geom
FROM
  coberturas.plus_pdo
WHERE 
trim(COALESCE(coberturas.plus_pdo.usos,'')) <> '' 
OR trim(COALESCE(coberturas.plus_pdo.vegetacion,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_tja.domain as codigo,
  coberturas.plus_tja.leyenda as categoria,
  coberturas.plus_tja.subcategor as subcategoria,
  'F0603704_PLUS_TARIJA' as source,
  coberturas.plus_tja.the_geom
FROM
  coberturas.plus_tja
 WHERE 
trim(COALESCE(coberturas.plus_tja.leyenda,'')) <> '' 
OR trim(COALESCE(coberturas.plus_tja.subcategor,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_pts.zae as codigo,
  coberturas.plus_pts.plus_uso as categoria,
  coberturas.plus_pts.plus_uso as subcategoria,
  'F0603726_PLUS_POTOSI_A2016' as source,
  coberturas.plus_pts.the_geom
FROM
  coberturas.plus_pts
WHERE
trim(COALESCE(coberturas.plus_pts.plus_uso,'')) <> '';
-->Adicionando índices
CREATE INDEX plus_the_geom_idx ON coberturas.plus USING gist (the_geom);

-->Agregando campos del geoSICOB
SELECT sicob_create_id_column('coberturas.plus');
SELECT sicob_add_geoinfo_column('coberturas.plus');
SELECT sicob_update_geoinfo_column('coberturas.plus');