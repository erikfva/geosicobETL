@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Plan Gral. de Manejo Forestal  (PGMF) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_pgmf%
set newlyrname=pgmf
call import.bat