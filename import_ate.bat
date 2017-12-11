@echo off
call config.bat
REM ********************************************************************************
REM **Importando Autorizaciones Transitorias Especiales (ATE) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603210_AUTORIZACIONES_TRANSITORIAS_ESPECIALES_
set lyrname=
call dosearch.bat
set newlyrname=ate
call import.bat