@echo off
call config.bat
REM ********************************************************************************
REM **Importando Plan Gral. de Manejo Forestal  (PGMF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603201_PGMF_
set lyrname=
call dosearch.bat
set newlyrname=pgmf
call import.bat