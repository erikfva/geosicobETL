-->Creando cobertura de predios para el POP
DROP TABLE IF EXISTS coberturas.predios_pop;
CREATE TABLE coberturas.predios_pop AS
WITH
grouppolygons AS (
	SELECT
    	res_adm, min(gv_id) as idref,
    	st_multi(
    		st_union(
    			the_geom                
			)
        )
        AS the_geom
    FROM
    	coberturas.pop_uso_vigente
    GROUP BY res_adm
),
buff AS (
	SELECT 
    	res_adm, idref,
		st_buffer(
			the_geom,
			5::float/111000, 'join=mitre mitre_limit=5.0'
		) as the_geom
	FROM 
    	grouppolygons
),
dissolve_area AS (
	SELECT 
    	res_adm, idref, st_union(the_geom) AS the_geom
	FROM (
    	SELECT
          res_adm, idref,
          st_buffer(
              st_makepolygon(
                  st_exteriorring(
                      (st_dump(the_geom)).geom
                  )
              ),
              -5::float/111000, 'join=mitre mitre_limit=5.0'
          ) as the_geom
        FROM  buff
	) t
    GROUP BY res_adm, idref
),
predios_pop_uso AS ( 
       SELECT 
        info.res_adm, 
        CASE WHEN COALESCE(	extract(year from info.fec_res),1800) < 1980 THEN
        	NULL 
        ELSE
        	info.fec_res
        END AS fec_res,
        info.raz_soc,
		CASE WHEN COALESCE(TRIM(info.nom_pro),'') = '' THEN 
 			NULL
		ELSE
  			nom_pro
  		END AS nom_pro,
        info.nom_aux, info.nom_rep, info.dep, info.prov, info.mun, info.zon_utm, info.ges, info.sup_pre, info.est_der, info.obs, a.the_geom
        FROM
        dissolve_area a INNER JOIN coberturas.pop_uso_vigente info ON ( a.idref = info.gv_id)
),
pop_faltante AS (
    SELECT 
      a.*
    FROM 
      coberturas.pop_vigente AS a LEFT JOIN
      predios_pop_uso AS b ON
      ST_Intersects(a.the_geom,b.the_geom) 
      AND -- al menos el 20% se sobreponga
      st_area(  ST_Intersection(st_makevalid(a.the_geom),b.the_geom)  ) > (st_area(a.the_geom) * 0.2)
    WHERE 
     b.res_adm IS NULL
),
predios_pop AS (
    SELECT res_adm, fec_res, raz_soc, nom_pro, nom_aux, nom_rep, dep, prov, mun, zon_utm, ges,
     sup_pre, est_der, obs, the_geom, 'coberturas.pop_uso_vigente' AS source FROM predios_pop_uso 
    UNION ALL
    SELECT 
     res_adm, fec_res,  raz_soc, nom_pro, nom_aux, nom_rep, dep, prov, mun, zon_utm, ges,
     sup_pre, est_der, obs, the_geom, 'coberturas.pop_vigente' AS source
    FROM
      pop_faltante
)
SELECT * FROM 
predios_pop;
-->Adicionando indices
CREATE INDEX predios_pop_idx_res_adm ON coberturas.predios_pop
  USING btree (res_adm COLLATE pg_catalog."default");
CREATE INDEX predios_pop_idx_raz_soc ON coberturas.predios_pop
  USING btree (raz_soc COLLATE pg_catalog."default");
CREATE INDEX predios_pop_idx_nom_pro ON coberturas.predios_pop
  USING btree (nom_pro COLLATE pg_catalog."default");
CREATE INDEX predios_pop_the_geom_geom_idx ON coberturas.predios_pop
  USING gist (the_geom public.gist_geometry_ops_2d);
-->Agregando campos del geogv
SELECT gv_create_id_column('coberturas.predios_pop');
SELECT gv_add_geoinfo_column('coberturas.predios_pop');
SELECT gv_update_geoinfo_column('coberturas.predios_pop');
-->Filtrando y eliminando los POP actualizados (deber�an estar NO VIGENTES)
DELETE FROM coberturas.predios_pop
WHERE gv_id IN (
    SELECT
     a.gv_id
    FROM
    coberturas.predios_pop a INNER JOIN 
    coberturas.predios_pop b ON (
        a.gv_id <> b.gv_id AND
        a.ges < b.ges AND
        ST_Intersects(a.the_geom,b.the_geom) AND 
        st_area(  ST_Intersection(st_makevalid(a.the_geom),st_makevalid(b.the_geom) )  ) > 
        (st_area(a.the_geom) * 0.7) 
    )
);
-->Actualizando fecha de resolucion y propietario en registros que tienen valores nulos
UPDATE coberturas.predios_pop
SET fec_res = t.fec_res, nom_pro = t.nom_pro
FROM (
  SELECT pp.gv_id, pv.fec_res, pv.nom_pro FROM
  coberturas.predios_pop pp 
  INNER JOIN coberturas.pop_vigente pv ON (
      pp.res_adm = pv.res_adm
  )
  WHERE
  pp.fec_res IS NULL
  OR
  pp.nom_pro IS NULL
) t
WHERE
coberturas.predios_pop.gv_id = t.gv_id;
