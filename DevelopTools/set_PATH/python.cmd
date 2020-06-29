@echo off
@REM 改成UTF-8，中文才不會亂碼 
if not defined UTF8 (
	set "UTF8=Y"
	mode con cp select=65001 >nul
)


@REM 防止重複設置變數

if defined PATH_PY_STAT ( exit /b )

@REM set python launcher to path

set "PDEV_PATH=%PDEVTOOLS%\Python\Launcher;%PDEV_PATH%"

set "PYTHONROOT=%USERPROFILE%\AppData\Local\Programs\Python"

set "PYTHONIOENCODING=utf-8"

@REM set "PYTHONHOME=%USERPROFILE%\AppData\Local\Programs\Python\Python38"


@REM set "PYTHONHOME=%PDEVTOOLS%\Python"

@REM set python interpreter to path

@REM path=%PDEVTOOLS%\Python\Python37;%path%
@REM path=%PDEVTOOLS%\Python\Python37\App\Python;%path%
@REM path=%PDEVTOOLS%\Python\Python37\App\Python\Scripts;%path%

@REM 表明已經設置過變數

set "PATH_PY_STAT=Y"
:end
