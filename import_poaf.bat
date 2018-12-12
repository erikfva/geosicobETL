@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Plan Operativo Anual Forestal (POAF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_poaf%
set newlyrname=poaf
call import.bat