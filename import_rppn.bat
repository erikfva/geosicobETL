@echo off
call config.bat
REM ********************************************************************************
REM **Importando Reservas Privada de Patrimonio  Natural (RPPN) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrsearch=B0603204_RPPN_
set lyrname=
call dosearch.bat
set newlyrname=rppn
call import.bat