@echo off
@REM 改成UTF-8，中文才不會亂碼 
if not defined UTF8 (
	set "UTF8=Y"
	mode con cp select=65001 >nul
)

@REM 防止重複設置變數

if defined PATH_GRAPHVIZ_STAT ( exit /b )

@REM set Graphiz to path 

set "PDEV_PATH=C:\PDEVHOME\DevelopTools\Graphviz\bin;%PDEV_PATH%"

@REM 表明已經設置過變數

set "PATH_GRAPHVIZ_STAT=Y"
:end
