@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Reservas Privada de Patrimonio  Natural (RPPN) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************

set lyrname=%lyr_rppn%
set newlyrname=rppn
call import.bat