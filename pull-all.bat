@echo off
setlocal EnableDelayedExpansion
set formatlib=%~dp0lib\formatlib.bat
set gitlib=%~dp0lib\gitlib.bat


:: Iterates through sub directories and performs git status and pull (with prune)
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
FOR /D %%f in (*) DO (
	set name= %%f                                       
	call %gitlib% :detect_remote "%%f" remote
	call %formatlib% :format_title "%%f" "!remote!" 80
	IF !isGit! EQU 1 (
		call %gitlib% :get_status %%f "Status"
		call %gitlib% :get_status %%f "Ignored Files" !incIgnore!
        IF !clean! EQU 1 (
            call %gitlib% :get_clean %%f
        )
		call %gitlib% :get_pull %%f
	)
	echo.
)
exit /b