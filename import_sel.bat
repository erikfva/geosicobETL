@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando SERVIDUMBRES ECOLOGICAS (SEL) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_selpas%
set newlyrname=selpas
call import.bat
REM ** Adicionando la fuente de informacion **
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% ADD COLUMN source TEXT DEFAULT '%lyrname%';" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%

set lyrname=%lyr_seltum%
set newlyrname=seltum
call import.bat
REM ** Adicionando la fuente de informacion **
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% ADD COLUMN source TEXT DEFAULT '%lyrname%';" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%

set lyrname=%lyr_seltpfp%
set newlyrname=seltpfp
call import.bat
REM ** Adicionando la fuente de informacion **
psql -h %pghost% -p %pgport% -c "ALTER TABLE %pgschema%.%newlyrname% ADD COLUMN source TEXT DEFAULT '%lyrname%';" postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%

REM ********************************************************************************
REM **Creando cobertura de SERVIDUMBRES ECOLOGICAS (SEL)**
REM ********************************************************************************
psql -h %pghost% -p %pgport% -f servidumbres_ecologicas.sql postgresql://%pguser%:%pgpass%@%pghost%/%pgdb%
