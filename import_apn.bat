@echo off
call config.bat
REM ********************************************************************************
REM **Importando Areas Protegidas Nacionales (APN) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=F0603702_AREAS_PROTEGIDAS_NACIONALES_
set lyrname=
set newlyrname=apn
call dosearch.bat
call import.bat