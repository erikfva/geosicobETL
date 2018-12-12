@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Areas Protegidas Nacionales (APN) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_apn%
set newlyrname=apn
call import.bat