@echo off
call config.bat
REM ********************************************************************************
REM **Importando Asociación Sociales del Lugar (ASL) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603212_CONCESIONES_ASL
REM set lyrname=B0603212_CONCESIONES_ASL
set lyrname=
set newlyrname=asl
call dosearch.bat
call import.bat
