@echo off
setlocal EnableDelayedExpansion
set formatlib=%~dp0lib\formatlib.bat
set gitlib=%~dp0lib\gitlib.bat


:: Performs git checkout and pull to set-up a new remote and local branch
:: Author: Stewart Bonnick (stewart.bonnick@autoclavestudios.com)


::-----------------------------------------------------------------------
::|                          Parameters                                 |
::-----------------------------------------------------------------------

set incIgnore=0

:parse
IF [%~1] == [] GOTO endparse
IF not [%~1] == [] set branch=%~1
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
	call %gitlib% :get_checkout %cd% !branch!
	call %gitlib% :get_push %cd% !branch!
)
echo.
call %gitlib% :detect_remote "%cd%" remote
call %formatlib% :format_title "!name!" "!remote!" 80
echo.
exit /b