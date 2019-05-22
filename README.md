# geosicobETL
## Scripts para importar las coberturas desde la personal geodatabase GDB hacia PostGIS.
El primer script que se debe ejecutar es **layerlist.bat** que genera el listado de las capas de la base de datos GDB,
gabando el resultado en el archivo **layerlist.txt**.
## Para adicionar una nueva capa que se requiera importar
### Paso 1.
Edite el archivo **layers.bat** y al final declare una variable con el nombre de la capa asignado en  el archivo .gdb
``` shell
.
.
.
set lyr_pgibt=_06030204_PGIBT
```
### Paso 2.
Cree un nuevo archivo .bat en el directorio, ej: **import_pgibt.bat**, con el siguiente contenido
``` shell
@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando PLAN DE GESTION INTEGRAL DE BOSQUES Y TIERRA (PGIBT) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_pgibt%
set newlyrname=pgibt
call import.bat

REM ** Adicionando indices **
(echo CREATE INDEX %newlyrname%_idx_res_adm ON %pgschema%.%newlyrname% USING btree (res_adm^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
(echo CREATE INDEX %newlyrname%_idx_est ON %pgschema%.%newlyrname% USING btree (est_der^^^);) | psql -h %pghost% -p %pgport% -U %pguser% -d %pgdb%
```