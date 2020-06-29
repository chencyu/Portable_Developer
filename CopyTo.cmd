@echo off 
mode con cp select=65001 > nul
@REM Copy to Specified path 

set "COPYROOT_DIR=%~dp0"

echo 複製整個PDev到目的路徑資料夾 
echo 例:如果要複製到隨身碟[F:\] 
echo     則輸入 F:\ 
echo     最後會存放成 
echo: 
echo     F:\Portable_Developer\ 
echo            ─ Coding\ 
echo                   ─ C++\ 
echo                   ─ C\ 
echo                   ─ Python\ 
echo            ─ PDevUser\ 
echo            ─ Launch_VSCode.cmd 
echo            ─ CopyTo.cmd 
echo            ........ 
echo:

:inpdest
echo 請輸入目的路徑資料夾 
set /p dest=目的路徑= 

@REM 防呆機制 
@REM 自動補反斜線[\] 
if "%dest:~-1%" NEQ "\" (
    set "dest=%dest%\"
)

@REM /ETA   顯示預估所需時間 
@REM /E     複製所有子資料夾，包含空資料夾 
@REM /XO    排除舊檔案，只複製較新的檔案 
@REM /MT:1  使用單執行緒 

if exist "%dest%" (
	robocopy %COPYROOT_DIR%DevelopTools\Python\Launcher\. %dest%Portable_Developer\DevelopTools\Python\Launcher\
	copy %COPYROOT_DIR%DevelopTools\Python\Source.url %dest%Portable_Developer\DevelopTools\Python\
	robocopy %COPYROOT_DIR%. %dest%Portable_Developer\ /E /XO /MT:1 /XD %COPYROOT_DIR%USER\ /XD %COPYROOT_DIR%WorkSpace\ /XD %COPYROOT_DIR%DevelopTools\mingw64 /XD %COPYROOT_DIR%DevelopTools\Python /XD %COPYROOT_DIR%DevelopTools\VSCode_Program_File /XF *.tmp /XF *.pdevlog
) else (
	@REM 純粹用來顯示找不到該路徑的訊息 
	@pushd "%dest%" 
	goto inpdest
)

@pause
