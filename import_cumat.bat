@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Capacidad Uso Mayor de la Tierra (CUMAT) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_cumat%
set newlyrname=cumat
call import.bat