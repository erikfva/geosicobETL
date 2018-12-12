@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Reservas Forestales (RF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************
set lyrname=%lyr_rf%
set newlyrname=rf
call import.bat