:: Copyright by SyneArt <sa@syneart.com>
@echo off&cls&title InstallTheme&color 0F&mode con cols=38 lines=10
setlocal enableextensions enabledelayedexpansion
set texPath=nul

REM For TeXLive
call:pushProgress 1 & call tlmgr --version 1>nul 2>&1 && (
	for /f "tokens=1* delims=:" %%a in ('tlmgr --version') do (
		if "%%a"=="tlmgr using installation" (
			set rootTexPath=%%b
			set texPath=#%%b&set texPath=!texPath:# =!\texmf-dist\tex\latex\beamer\
		)
	)
	call:copyFile .\themes, *.sty&call:copyFile .\art, *.jpg
	if !errorlevel!==1 (call:pushCopyError&goto exit)
	for /f "tokens=2* delims=:b" %%a in ('tlmgr search --file texhash.exe') do (
		call:pushProgress 2 & call !rootTexPath!/b%%a >nul 2>&1
	)
	if !errorlevel!==1 (call:pushCompileError&goto exit)
)

REM For MiKTeX
call:pushProgress 3 & call initexmf --version 1>nul 2>&1 && (
	for /f "tokens=1* delims=: " %%a in ('initexmf --report') do (
		if exist %%b\tex\latex\beamer\base\ set texPath=%%b\tex\latex\beamer\base\
	)
	if !texPath!==nul (call:pushBeamerError&goto exit)
	call:copyFile .\themes, *.sty&call:copyFile .\art, *.jpg
	if !errorlevel!==1 (call:pushCopyError&goto exit)
	call:pushProgress 4 & initexmf --admin --update-fndb >nul 2>&1
	if !errorlevel!==1 (call:pushCompileError&goto exit)
)

if !texPath!==nul (
	call:echo "Please install LaTeX first."
	color E3&set /p=&goto exit
)

call:echo "Install Theme Successful (^^)"&color 2A&ping 127.0.0.1 -n 3 >nul&goto exit

:pushBeamerError
call:echo "Please install Beamer on MiKTeX first."
color E3&set /p=&goto exit

:pushCopyError
call:echo "Not Found Path, please feedback."
color 4C&set /p=&goto exit

:pushCompileError
call:echo "Please stop LaTeX Compile first."
color 4C&set /p=&goto exit

:pushProgress
call:echo "Installing Theme , Wait .. [ %~1 of 4 ]"
goto exit

:echo
cls&echo.&echo.&echo.&echo.&echo %~1
goto exit

:copyFile
FOR /R %~1 %%c in (%~2) DO (
	set themesFile=%%c&set themesFile=!themesFile:%~dp0=!
	echo F | xcopy /Y "%%c" "!texPath!!themesFile!" 1>nul 2>&1
)
:exit
