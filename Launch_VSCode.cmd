@echo off
@REM 改成UTF-8，中文才不會亂碼 
mode con cp select=65001 >nul


@REM Set Path
@REM Make sure basic.cmd is the first script to run
call "DevelopTools\set_PATH\basic.cmd"
for %%i in ("DevelopTools\set_PATH\*.cmd") do (
    if "%%i" NEQ "DevelopTools\set_PATH\basic.cmd" (
        call "%%i"
    )
)


@REM 檔案總管切換到連結後的目錄
powershell -ExecutionPolicy UnRestricted -c "Set-Item -Path Env:Path -Value ($Env:PDEV_PATH + $Env:Path); (linked_pwd jump)"


@REM 以繁體中文為預設啟動VSCode
set "OLD_PATH=%PATH%"
set "PATH=%PDEV_PATH%%PATH%"

if not exist "%PDEVTOOLS%\VSCode_Program_File" (
	echo.
	echo 尚未安裝VSCode，請啟動__PowerShell.cmd 並執行 `install vscode` 來安裝 

	set /p "YINSTALL=是否立即安裝(y/n)?"

    @REM echo Portable VSCode has not been installed, execute __PowerShell.cmd and run `install vscode` to install it 

) else (
	Code.cmd --locale=zh-tw
)

if "%YINSTALL%" == "y" (
	set YINSTALL=
	start /wait "Windows PowerShell" powershell -ExecutionPolicy UnRestricted -c "Set-Item -Path Env:Path -Value ($Env:PDEV_PATH + $Env:Path); pdev; install vscode"
	sleep 1 >nul
	Code.cmd --locale=zh-tw
)

