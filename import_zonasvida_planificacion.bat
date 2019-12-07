@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando ZONAS DE VIDA DEL MINISTERIO DE PLANIFICACION de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_zonasvidaplanificacion%
set newlyrname=zonas_vida_planificacion
call import.bat

REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_zon_vid ON %pgschema%.%newlyrname% USING btree (zon_vid);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%