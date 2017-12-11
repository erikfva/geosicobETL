@echo off
call config.bat
REM ********************************************************************************
REM **Importando Reservas Forestales (RF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************
set lyrname=F0603712_RESERVAS_FORESTALES
set newlyrname=rf
call import.bat