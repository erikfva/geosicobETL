@echo off
call config.bat
REM ********************************************************************************
REM **Importando Capacidad Uso Mayor de la Tierra (CUMAT) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=F0603715_CUMAT
set newlyrname=cumat
call import.bat