@echo off
call config.bat
REM ********************************************************************************
REM **Importando Desmontes Ilegales con Proceso Administrativo Sancionatorio (DPAS) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=PAS_DESMONTES_ILEGALES_
set lyrname=
call dosearch.bat

if "%lyrname%"=="" ( GOTO EOF )

set newlyrname=dpas
call import.bat

:EOF