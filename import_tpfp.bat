@echo off
call config.bat
call layers.bat
REM ********************************************************************************
REM **Importando Tierras de Producci�n Forestal Permanente (TPFP) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************
set lyrname=%lyr_tpfp%
set newlyrname=tpfp
import.bat