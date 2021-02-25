# geosicobETL

## Scripts para importar las coberturas desde la personal geodatabase GDB hacia PostGIS.
![drawing](https://docs.google.com/drawings/d/1K83FFj45Nvs3X6xo_pj4DwLWPgffe28jAklbAdMCrD4/export/png)

Edite el archivo **_config.bat_** y configure los parámetros de conexión a la base de datos PostgreSQL y el archivo .GDB de base de dtos personal de ESRI.

## Importando las capas

### Importando predios_referenciales

La capa ha sido creada en base a diferentes fuentes de datos.
Primero debe descargar los archivos:

1. https://drive.google.com/file/d/1uR0y6WVzchjzyQifKpn9yvZnXWhJKi6k/view?usp=sharing
2. https://drive.google.com/file/d/1L15fUvScJkSJrumT3kjulOWZksPV0E16/view?usp=sharing

luego edite el archivo **import_referenciales.bat** y configure la ubicación de los archivos descargados, luego ejecute el archivo.

### Importando capas UMIG

Ejecute los archivos **.bat** de importación.

1.  import_apd.bat
2.  import_apn.bat
    .
    .

### Crear coberturas especiales.

Ejecute **create_predios_pop**

## Para adicionar una nueva capa que se requiera importar

### Paso 1.

Edite el archivo **layers.bat** y al final declare una variable con el nombre de la capa asignado en el archivo .g

```shell
.
.
.
set lyr_pgibt=_06030204_PGIBT
```

### Paso 2.

Cree un nuevo archivo .bat en el directorio, ej: **import_pgibt.bat**, con el siguiente contenido

```shell
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
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_res_adm ON %pgschema%.%newlyrname% USING btree (res_adm);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_est ON %pgschema%.%newlyrname% USING btree (est_der);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
```
