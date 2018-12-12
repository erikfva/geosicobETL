@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Areas Protegidas Municipales (APM) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_apm%
set newlyrname=apm
call import.bat
