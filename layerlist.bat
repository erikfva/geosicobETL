@echo off
call config.bat
REM ********************************************************************************
REM **Generando el listado de capas de la geodatabase UMIG ABT**
REM ********************************************************************************

(for /f "TOKENS=2 skip=3 delims=: " %%A in ('ogrinfo "%PATH_GDB%"') do ( 
		for /f "useback tokens=*" %%b in ('%%A') do echo %%~b 
	)
) > "layerlist.txt"