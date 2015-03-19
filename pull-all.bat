@echo off
call :color_init
setlocal EnableDelayedExpansion

REM Iterates through sub directories and performs git status and pull (with prune)
REM Author: Stewart Bonnick (stewart.bonnick@autoclavestudios.com)

echo.
echo --------------------------------------------------------------------------------
FOR /D %%i in (*) DO (
	set name= %%i                                       
	call :detect_remote %%i
	set remote=                                       !remote! 
	call :color 0a "!name:~0,40!"
	echo !remote:~-40!
	echo --------------------------------------------------------------------------------
	echo.
	IF !isGit! EQU 1 (
		call :color 03 "+++ Status"
		echo.
		echo.
		git -C %%i status -s
		echo.
		call :color 03 "+++ Pull"
		echo.
		echo.
		git -C %%i pull --prune
		echo.
	)
	echo --------------------------------------------------------------------------------
)
DEL X
exit /b


:detect_remote 
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


REM Below code or ideas are derived from various other peoples work. Originators are unknown -
REM as there are different flavours of the same snippets. All licences however are MIT or Apache 2.0

:color_init
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
echo.|set /P ="." > X
exit /b

:color
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
exit /b