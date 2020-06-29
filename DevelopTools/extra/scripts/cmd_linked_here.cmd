@echo off
@REM get_linked_current_path

pushd .


setlocal EnableDelayedExpansion

@REM Find PDevRoot which not linked
:fproot
set CUR_PATH=%CD%
cd ..
set UP_PATH=%CD%
set CUR_DIR=!CUR_PATH:%UP_PATH%=!
set CUR_DIR=%CUR_DIR:\=%
if "%CUR_DIR%" NEQ "Portable_Developer" (
    set LINKED_CUR_PATH=%CUR_DIR%\%LINKED_CUR_PATH%
    goto fproot
) else (
    if defined LINKED_CUR_PATH (
        set "LINKED_CUR_PATH=%LINKED_CUR_PATH:~,-1%"
        set "LINKED_CUR_PATH=%PDEVHOME%\%LINKED_CUR_PATH%"
    ) else (
        set "LINKED_CUR_PATH=%PDEVHOME%"
    )
)



@REM Passing local variable to globle
(
    endlocal
    set TMP_LINKED_CUR_PATH=%LINKED_CUR_PATH%
)
@REM Now we have LINKED_CUR_PATH outside of set/end local


@REM cd to linked here
cd /d "%TMP_LINKED_CUR_PATH%"
set TMP_LINKED_CUR_PATH=
cmd /d
