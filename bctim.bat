:: Copyright by SyneArt <sa@syneart.com>
@echo off&cls&title InstallTheme&color 0F&mode con cols=38 lines=10
setlocal enableextensions enabledelayedexpansion
echo.&echo.&echo.&echo.&echo Install Theme Now , Please Wait .. 
set texPath=nul

REM For TeXLive
call tlmgr --version 1>nul 2>&1 && (
	for /f "tokens=1* delims=:" %%a in ('tlmgr --version') do (
		if "%%a"=="tlmgr using installation" (
			set texPath="%%b"&set texPath=!texPath:" =!
			set texPath=!texPath:"=!
		)
	)
	set texPath=!texPath!\texmf-dist\tex\latex\beamer\
	call:copyFile .\themes, *.sty&call:copyFile .\art, *.jpg
	texhash >nul 2>&1
	if !errorlevel!==1 (call:checkError&goto exit)
)

REM For MiKTeX
call initexmf --version 1>nul 2>&1 && (
	for /f "tokens=1* delims=:" %%a in ('initexmf --report') do (
		if "%%a"=="UserInstall" (
			set texPath="%%b"&set texPath=!texPath:" =!
			set texPath=!texPath:"=!
		)
	)
	set texPath=!texPath!\tex\latex\beamer\base\
	call:copyFile .\themes, *.sty&call:copyFile .\art, *.jpg
	initexmf --admin --update-fndb >nul 2>&1
	if !errorlevel!==1 (call:checkError&goto exit)
)

if !texPath!==nul (
	cls&echo.&echo.&echo.&echo.&echo Please install LaTeX first.
	color E3&set /p=&goto exit
)

cls&echo.&echo.&echo.&echo.&echo Install Theme Successful ^^! :-P&color 2A&ping 127.0.0.1 -n 3 >nul&goto exit

:checkError
cls&echo.&echo.&echo.&echo.&echo Please stop LaTeX Compile first.
color 4C&set /p=

:copyFile
FOR /R %~1 %%c in (%~2) DO (
	set themesFile=%%c&set themesFile=!themesFile:%~dp0=!
	copy /Y "%%c" "!texPath!!themesFile!" >nul
)

:exit
