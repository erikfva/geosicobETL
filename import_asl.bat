@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Asociacion Sociales del Lugar (ASL) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_asl%
set newlyrname=asl
call import.bat
