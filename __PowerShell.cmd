@echo off
@REM 改成UTF-8，中文才不會亂碼 
mode con cp select=65001 >nul

:up
if exist "DevelopTools" (goto set)
cd ..
goto up

:set
@REM Make sure basic.cmd is the first script to run
call "DevelopTools\set_PATH\basic.cmd"
for %%i in ("DevelopTools\set_PATH\*.cmd") do (
    if "%%i" NEQ "DevelopTools\set_PATH\basic.cmd" (
        call "%%i"
    )
)

@REM cd to outset path
cd /d "%~dp0"


@REM launch powershell and cd to linked here

@REM Close not linked path explorer, and launch linked path explorer
powershell.exe -NoProfile -ExecutionPolicy Bypass -c "Set-Item -Path Env:Path -Value ($Env:PDEV_PATH + $Env:Path); (linked_pwd jump)"


@REM 
start "Windows PowerShell" powershell.exe -NoLogo -ExecutionPolicy Bypass