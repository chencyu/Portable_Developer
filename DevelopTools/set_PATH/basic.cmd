@echo off
@REM 改成UTF-8，中文才不會亂碼 
if not defined UTF8 (
	set "UTF8=Y"
	mode con cp select=65001 >nul
)

@REM 防止重複設置變數

if defined PATH_GEN_STAT ( exit /b )

@REM 設置變數PDevHome

set "PDEVROOT=C:\PDEVHOME"
set "PDEVWORKSPACE=%PDEVROOT%\WorkSpace"
set "PDEVTOOLS=%PDEVROOT%\DevelopTools"
set "PDEVLOGS=%PDEVTOOLS%\pdevlogs.pdevlog"

@REM 各項變數路徑使用PDev的而非主機的

set "USERNAME=USER"
set "USERPROFILE=%PDEVROOT%\%USERNAME%"
set "HOMEPATH=%PDEVROOT:~2%\%USERNAME%"
set "APPDATA=%USERPROFILE%\AppData\Roaming"
set "LOCALAPPDATA=%USERPROFILE%\AppData\Local"
@REM set "TEMP=%USERPROFILE%\AppData\Local\Temp"
@REM set "TMP=%USERPROFILE%\AppData\Local\Temp"
set "DOCUMENTS=%USERPROFILE%\Documents"
set "PS_SPACE=%DOCUMENTS%\WindowsPowerShell"
set "PS_PROFILE=%PS_SPACE%\Profile.ps1"

@REM load check_same.tmp
@REM if not exist, create it by date and time 

if not exist "%~dp0check_same_with_linked_pdev.tmp" (
    echo %date% %time% %random% %random% %random% %random% %random% > "%~dp0check_same_with_linked_pdev.tmp"
)
set /p linked_check=<"%~dp0check_same_with_linked_pdev.tmp"

@REM check if linked check_same.tmp exist
@REM if exist, and equal to current check_same.tmp
@REM skip creating junction symbolic link

if exist "%PDEVROOT%\DevelopTools\set_PATH\check_same_with_linked_pdev.tmp" (
    set /p here_check=<"%PDEVROOT%\DevelopTools\set_PATH\check_same_with_linked_pdev.tmp"
)
if "%here_check%" == "%linked_check%" (
    goto checkEVD
)

@REM create new junction to PDev

rmdir "%PDEVROOT%" >nul 2>nul
mklink /J "%PDEVROOT%" "%~dp0..\.." >nul 2>nul

@REM attrib /l +h "%PDEVROOT%"

:checkEVD

@REM if we don't have Environment Variable Directory, just create it 

if not exist "%USERPROFILE%" (
    mkdir "%USERPROFILE%"
)

if not exist "%APPDATA%" (
    mkdir "%APPDATA%"
)
if not exist "%LOCALAPPDATA%" (
    mkdir "%LOCALAPPDATA%"
)
if not exist "%TEMP%" (
    mkdir "%TEMP%"
)
if not exist "%DOCUMENTS%" (
    mkdir "%DOCUMENTS%"
)
if not exist "%PS_SPACE%" (
	mkdir "%PS_SPACE%"
)
if not exist "%PS_PROFILE%" (
	copy "%PDEVTOOLS%\extra\scripts\Lib\__Profile.ps1" "%PS_PROFILE%" >nul 2>nul
)


if not exist "%PDEVWORKSPACE%" (
    mkdir "%PDEVWORKSPACE%"
)

if not exist "%USERPROFILE%\Desktop" (
    mklink /J "%USERPROFILE%\Desktop" "%PDEVWORKSPACE%" >nul 2>nul
)

@REM Set Extra PATH
:sep

@REM set extra-bins to path

set "PDEV_PATH=%PDEVTOOLS%\extra\bin;"
set "PATH=%PATH%;%PDEVTOOLS%\extra\bin\7z"

@REM set extra-scripts to path

set "PDEV_PATH=%PDEVTOOLS%\extra\scripts;%PDEV_PATH%"

@REM set Junction to path

set "PDEV_PATH=%PDEVTOOLS%\extra\Junction;%PDEV_PATH%"

@REM set VSCode to path

@REM set "PDEV_PATH=%PDEVTOOLS%\VSCode_Program_File\bin;%PDEV_PATH%" 

@REM set PowerShell 7.0.0 to path

@REM set "PDEV_PATH=%PDEVTOOLS%\PowerShell\PowerShell-7.0.0-win-x64;%PDEV_PATH%"


@REM 表明已經設置過變數

set "PATH_GEN_STAT=Y"

:end
