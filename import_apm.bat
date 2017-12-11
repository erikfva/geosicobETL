@echo off
call config.bat
REM ********************************************************************************
REM **Importando Areas Protegidas Municipales (APM) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603702_AREAS_PROTEGIDAS_MUNICIPALES_
set lyrname=
set newlyrname=apm
call dosearch.bat
call import.bat
