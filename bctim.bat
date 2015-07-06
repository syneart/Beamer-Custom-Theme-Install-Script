:: Copyright 2014 by SyneArt <sa@syneart.com>
@echo off&cls&title Install&color 0F&mode con cols=38 lines=10
setlocal enableextensions enabledelayedexpansion
echo.&echo.&echo.&echo.&echo Install Theme Now ..
set str=!PATH: =/!&set str=!str:(x86)=[x86]!&set MiKTeXPath=nul
FOR %%b in (!str!) DO (
	set nowStr=%%b&set MiKTeXStr=x!nowStr:MiKTeX=!
	if not !MiKTeXStr!==x!nowStr! set MiKTeXPath=!nowStr!
)
if !MiKTeXPath!==nul (
	cls&echo.&echo.&echo.&echo.&echo 請先安裝 MiKTeX, 再執行本安裝
	color E3&set /p=&goto exit
)
set MiKTeXPath=!MiKTeXPath:miktex\bin\=!&set MiKTeXPath=!MiKTeXPath:x64\=!
set MiKTeXPath=!MiKTeXPath:/= !&set MiKTeXPath=!MiKTeXPath:[x86]=(x86)!
if not exist "!MiKTeXPath!tex\latex\beamer\" (
	cls&echo.&echo.&echo.&echo.&echo 請先安裝 Beamer, 再執行本安裝
	color E3&set /p=&goto exit
)
call:copyFile .\themes, *.sty&call:copyFile .\art, *.jpg
initexmf --admin --update-fndb >nul
if !errorlevel!==1 (
	cls&echo.&echo.&echo.&echo.&echo 請先停止編譯 MiKTeX 專案, 再執行
	color 4C&set /p=&goto exit
)
cls&echo.&echo.&echo.&echo.&echo Install Theme Successful ^^!&color 2A&ping 127.0.0.1 -n 3 >nul&goto exit

:copyFile 
FOR /R %~1 %%c in (%~2) DO (
	set themesFile=%%c&set themesFile=!themesFile:%~dp0=!
	copy /Y "%%c" "!MiKTeXPath!tex\latex\beamer\base\!themesFile!" >nul
)

:exit
