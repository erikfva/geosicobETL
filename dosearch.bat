for /F "tokens=*" %%i in ('findstr "%lyrsearch%" layerlist.txt') do (
    REM set str=%%i
    REM if not x%str:%lyrsearch%=%==x%str% set lyrname=%%i
		REM endlocal
		set lyrname=%%i
)