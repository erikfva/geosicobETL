drop table if exists coberturas.predios_tioc; create table coberturas.predios_tioc as select * from coberturas.predios_titulados where titulo LIKE '%TIOC%' or titulo LIKE '%TCO%';  
