@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Areas Protegidas Departamentales (APD) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_apd%
set newlyrname=apd
call import.bat
