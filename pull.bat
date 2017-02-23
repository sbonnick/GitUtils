@echo off
setlocal EnableDelayedExpansion
set formatlib=%~dp0lib\formatlib.bat
set gitlib=%~dp0lib\gitlib.bat


:: Performs git status and pull (with prune) on current directory
:: Author: Stewart Bonnick (stewart.bonnick@autoclavestudios.com)


::-----------------------------------------------------------------------
::|                          Parameters                                 |
::-----------------------------------------------------------------------

set incIgnore=0
set clean=0

:parse
IF "%~1"=="" GOTO endparse
IF "%~1"=="-i" set incIgnore=1
IF "%~1"=="--ignore" set incIgnore=1
IF "%~1"=="-c" set clean=1
IF "%~1"=="--clean" set clean=1
SHIFT
GOTO parse
:endparse


::-----------------------------------------------------------------------
::|                          Main Code                                  |
::-----------------------------------------------------------------------

echo.
for %%* in (.) do (set name=%%~n*)
call %gitlib% :detect_remote "%cd%" remote
call %formatlib% :format_title "!name!" "!remote!" 80
IF !isGit! EQU 1 (
    call %gitlib% :get_status %cd% "Status"
    call %gitlib% :get_status %cd% "Ignored Files" !incIgnore!
    IF !clean! EQU 1 (
            call %gitlib% :get_clean %cd%
        )
    call %gitlib% :get_pull %cd%
)
echo.
exit /b