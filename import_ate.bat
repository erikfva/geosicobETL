@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Autorizaciones Transitorias Especiales (ATE) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_ate%
set newlyrname=ate
call import.bat