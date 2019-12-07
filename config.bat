set PATH_OGR2OGR=C:\Program" Files"\"QGIS 3.11"\bin\
REM set PATH_OGR2OGR=E:\PostgreSQL\12\bin\
set PATH_GDB="J:\Abt 2019\Geodatabase.gdb"
set pghost=localhost
set pgport=5433
set pgdb=geovision
set pguser=geovision
set pgpass=Geo2019*
REM ******************
REM * El password para el usuario "pguser" debe configurarse en el archivo .pgpass del sistema.
REM * On Microsoft Windows the file is named %APPDATA%\postgresql\pgpass.conf (where %APPDATA% refers to the Application Data subdirectory in the user's profile).
REM * El formato es -> hostname:port:database:username:password
REM ******************
set pgschema=coberturas
set pgsrid=3003
set pggeom=the_geom
REM set pgencoding="UTF-8"
REM setx GDAL_DATA "C:\Program Files\QGIS 3.2\share\epsg_csv"
SETLOCAL ENABLEEXTENSIONS EnableDelayedExpansion

