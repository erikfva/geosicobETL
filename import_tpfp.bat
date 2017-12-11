@echo off
call config.bat
REM ********************************************************************************
REM **Importando Tierras de Producción Forestal Permanente (TPFP) de la cobertura de la geodatabase UMIG ABT**
REM ********************************************************************************
set lyrname=F0603718_TPFP_A2003
set newlyrname=tpfp
import.bat