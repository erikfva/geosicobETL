@echo off
call config.bat
REM ********************************************************************************
REM **Importando Areas Protegidas Departamentales (APD) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603702_AREAS_PROTEGIDAS_DEPARTAMENTALES_
set lyrname=
set newlyrname=apd
call dosearch.bat

call import.bat