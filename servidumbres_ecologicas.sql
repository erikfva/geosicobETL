-->Creando cobertura de servidumbres ecologicas mediante "merge" de las capas
--> selpas, seltum y seltpfp.
DROP TABLE IF EXISTS coberturas.sel;
CREATE TABLE coberturas.sel AS
SELECT * FROM coberturas.selpas
NATURAL FULL OUTER JOIN (SELECT * FROM coberturas.seltum) t2 
NATURAL FULL OUTER JOIN (SELECT * FROM coberturas.seltpfp) t3;
DROP TABLE IF EXISTS coberturas.selpas CASCADE;
DROP TABLE IF EXISTS coberturas.seltpfp CASCADE;
DROP TABLE IF EXISTS coberturas.seltum CASCADE;