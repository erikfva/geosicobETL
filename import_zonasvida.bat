@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando ZONAS DE VIDA de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_zonasvida%
set newlyrname=zonas_vida
call import.bat

REM ** Adicionando indices **
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_cod ON %pgschema%.%newlyrname% USING btree (cod);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
psql -h %pghost% -p %pgport% -c "CREATE INDEX %newlyrname%_idx_zon_vid ON %pgschema%.%newlyrname% USING btree (zon_vid);" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%