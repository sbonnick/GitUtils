@echo off
call :color_init
setlocal EnableDelayedExpansion

:: Iterates through sub directories and performs git status and pull (with prune)
:: Author: Stewart Bonnick (stewart.bonnick@autoclavestudios.com)


::-----------------------------------------------------------------------
::|                          Parameters                                 |
::-----------------------------------------------------------------------

set incIgnore=0

:parse
IF "%~1"=="" GOTO endparse
IF "%~1"=="-i" set incIgnore=1
IF "%~1"=="--ignore" set incIgnore=1
SHIFT
GOTO parse
:endparse


::-----------------------------------------------------------------------
::|                          Main Code                                  |
::-----------------------------------------------------------------------

echo.
echo --------------------------------------------------------------------------------
FOR /D %%i in (*) DO (
	set name= %%i                                       
	call :detect_remote %%i
	set remote=                                       !remote! 
	call :color 0a "!name:~0,40!"
	echo !remote:~-40!
	echo --------------------------------------------------------------------------------
	IF !isGit! EQU 1 (
		call :get_status %%i
		call :get_status %%i !incIgnore!
		call :get_pull %%i
	)
	echo.
	echo --------------------------------------------------------------------------------
)
call :color_dispose
exit /b


::-----------------------------------------------------------------------
::|                          Functions                                  |
::-----------------------------------------------------------------------

:detect_remote -- <Folder>
IF EXIST %~1\.git (
	git -C %~1 rev-parse --symbolic-full-name --abbrev-ref @{u} > temp_remote.txt
	set isGit=1
) ELSE (
	echo.|set /P ="NOT A GIT REPOSITORY" > temp_remote.txt
	set isGit=0
)
set /p remote=<temp_remote.txt
DEL temp_remote.txt
exit /b

:get_status -- <Folder> <Include Ignore Print>
set exe=git -C %~1 status -s
set label="Status"
IF [%~2] == [0] ( exit /b )
IF [%~2] == [1]  (
	set exe=git -C %~1 status -s --ignored
	set label="Ignored Files"
)
!exe! > temp_status.txt
for /f %%t in ("temp_status.txt") do set size=%%~zt
if !size! GTR 0 (
	call :format_label !label!
	!exe!
)
DEL temp_status.txt
exit /b

:get_pull -- <Folder>
call :format_label "Pull"
git -C %~1 pull --prune
exit /b

:format_label -- <Label>
echo.
call :color 03 "+++ %~1"
echo.
echo.
exit /b


:: Below code or ideas are derived from various other peoples work. Originators are unknown -
:: as there are different flavours of the same snippets. All licences however are MIT or Apache 2.0

:color_init
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
echo.|set /P ="." > X
exit /b

:color_dispose
DEL X
exit /b

:color  -- <Color Code> <Label>
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
exit /b