-->Creando cobertura de PLUS de Bolivia
DROP TABLE IF EXISTS coberturas.plus;
CREATE TABLE coberturas.plus AS
SELECT 
  coberturas.plus_scz.cod_plus as codigo,
  coberturas.plus_scz.cat_plus as categoria,
  coberturas.plus_scz.sub_cat as subcategoria,
  '_06030807_GADSC_PLUS_SANTA_CRUZ' as source,
  coberturas.plus_scz.the_geom
FROM
  coberturas.plus_scz
WHERE 
trim(COALESCE(coberturas.plus_scz.cat_plus,'')) <> '' 
OR trim(COALESCE(coberturas.plus_scz.sub_cat,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_ben.cod_plus as codigo,
  coberturas.plus_ben.cat_plus as categoria,
  '' as subcategoria,
  '_06030809_GADBE_PLUS_BENI' AS source,
  coberturas.plus_ben.the_geom
FROM
  coberturas.plus_ben
WHERE
 trim(COALESCE(coberturas.plus_ben.cat_plus,'')) <> '' 
UNION ALL
SELECT 
  '' as codigo,
  coberturas.plus_pdo.cat_plus as categoria,
  coberturas.plus_pdo.subcat_uso as subcategoria,
  '_06030810_GADP_PLUS_PANDO' as source,
  coberturas.plus_pdo.the_geom
FROM
  coberturas.plus_pdo
WHERE 
trim(COALESCE(coberturas.plus_pdo.cat_plus,'')) <> '' 
OR trim(COALESCE(coberturas.plus_pdo.subcat_uso,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_tja.cod_zae as codigo,
  coberturas.plus_tja.cat_zae as categoria,
  coberturas.plus_tja.subcat_zae as subcategoria,
  '_06030812_GADTJ_PLUS_TARIJA' as source,
  coberturas.plus_tja.the_geom
FROM
  coberturas.plus_tja
 WHERE 
trim(COALESCE(coberturas.plus_tja.cat_zae,'')) <> '' 
OR trim(COALESCE(coberturas.plus_tja.subcat_zae,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_pts.cod_zae as codigo,
  coberturas.plus_pts.cod_zae as categoria,
  coberturas.plus_pts.sub_cat_ma as subcategoria,
  '_06030814_GADPT_PLUS_POTOSI' as source,
  coberturas.plus_pts.the_geom
FROM
  coberturas.plus_pts
WHERE
trim(COALESCE(coberturas.plus_pts.cod_zae,'')) <> ''
OR trim(COALESCE(coberturas.plus_pts.sub_cat_ma,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_chq.cod_zae as codigo,
  coberturas.plus_chq.sub_cat_ma as categoria,
  coberturas.plus_chq.sub_cat_me as subcategoria,
  '_06030813_GADCH_PLUS_CHUQUISACA' as source,
  coberturas.plus_chq.the_geom
FROM
  coberturas.plus_chq
WHERE
trim(COALESCE(coberturas.plus_chq.cod_zae,'')) <> ''
OR trim(COALESCE(coberturas.plus_chq.sub_cat_ma,'')) <> ''
UNION ALL
SELECT 
  coberturas.plus_cbba.cod_uso as codigo,
  coberturas.plus_cbba.cat_uso as categoria,
  '' as subcategoria,
  '_06030811_GADCB_USO_ACTUAL_COCHABAMBA' as source,
  coberturas.plus_cbba.the_geom
FROM
  coberturas.plus_cbba
WHERE
trim(COALESCE(coberturas.plus_cbba.cod_uso,'')) <> ''
OR trim(COALESCE(coberturas.plus_cbba.cat_uso,'')) <> ''
;
-->Adicionando indices
CREATE INDEX plus_the_geom_idx ON coberturas.plus USING gist (the_geom);

-->Agregando campos de geovision
SELECT gv_create_id_column('coberturas.plus');
SELECT gv_add_geoinfo_column('coberturas.plus');
SELECT gv_update_geoinfo_column('coberturas.plus');