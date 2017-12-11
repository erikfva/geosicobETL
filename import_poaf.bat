@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan Operativo Anual Forestal (POAF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603205_POAF_
set lyrname=
call dosearch.bat
set newlyrname=poaf
call import.bat