@echo off

REM This batch require cygwin to be installed even if
REM run from DOS prompt

if "%1"=="" (
	@echo Usage : gogo token
	@echo   if token exist in gogo_dic.bat go to matching dir
	@echo   if token does not exist in gogo_dic.bat add current dir in gogo_dic.bat 
	@echo   WEBDEVBIN env. var. must be define, and point to 'gogo.bat' directory
	@echo   !!!!!!!! This script require cygwin to be installed !!!!!!!!!!!!!
	@echo Example1 :
	@echo   C:\tmp^>gogo ici         ---^> add C:\tmp as ici
	@echo Example2 ^(after example1^) :
	@echo   D:\utils^>gogo ici         ---^> go to C:\tmp 
	@echo.
	@echo Current bookmark defined in dictionnary :
	if exist %DEVTOOLS%\gogo_dic.bat (
 		type %DEVTOOLS%\gogo_dic.bat
	) else (
		@echo "dictionnary (%DEVTOOLS%/gogo_dic.bat) does not exist"
	)

	goto :end
)

if exist %DEVTOOLS%\gogo_dic.bat (
	call %DEVTOOLS%\gogo_dic.bat
)

findstr /c:"set %1=" %DEVTOOLS%\gogo_dic.bat > NUL

if %errorlevel%==0 (
	call cd /d "%%%1%%" 
) else (
	@echo adding current dir in %DEVTOOLS%\gogo_dic.bat 
	cd > _tmpfile
	sed "s/^/set %1=/" _tmpfile >> %DEVTOOLS%\gogo_dic.bat
	del _tmpfile
)

:end
