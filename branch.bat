@echo off
setlocal EnableDelayedExpansion
set formatlib=%~dp0lib\formatlib.bat
set gitlib=%~dp0lib\gitlib.bat


:: Performs git checkout and pull to set-up a new remote and local branch
:: Author: Stewart Bonnick (stewart.bonnick@autoclavestudios.com)


::-----------------------------------------------------------------------
::|                          Parameters                                 |
::-----------------------------------------------------------------------


set remove=0

:parse
IF "%~1"=="" GOTO endparse
IF "%~1"=="-r" set remove=1
IF "%~1"=="--remove" set remove=1
IF not "%~1"=="" set branch=%~1
SHIFT
GOTO parse
:endparse

IF [!branch!] == [] (
	echo. 
    echo. Incorrect parameters
	echo.   Usage: branch [Branch Name] [--remove|-r]
	exit /b
)

::-----------------------------------------------------------------------
::|                          Main Code                                  |
::-----------------------------------------------------------------------

echo.
for %%* in (.) do (set name=%%~n*)
call %gitlib% :detect_remote "%cd%" remote
call %formatlib% :format_title "!name!" "!remote!" 80
IF !isGit! EQU 1 (
    IF [!remove!] == [0] ( 
        call %gitlib% :get_checkout %cd% !branch!
        call %gitlib% :get_push %cd% !branch!
    )
    IF [!remove!] == [1] ( 
        call %gitlib% :get_checkout %cd% "master"
        call %gitlib% :get_pull %cd% "master"
        call %gitlib% get_remove_branch %cd% !branch!
    )
)
echo.
call %gitlib% :detect_remote "%cd%" remote
call %formatlib% :format_title "!name!" "!remote!" 80
echo.
exit /b