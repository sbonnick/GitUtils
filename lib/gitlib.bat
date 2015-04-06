@echo off
set formatlib=%~dp0formatlib.bat
call:%*
exit /b

::-----------------------------------------------------------------------
::|                          Functions                                  |
::-----------------------------------------------------------------------

:init_git -- <formatlib>
set formatlib=%~1
exit /b

:detect_remote -- <Folder> <Variable>
IF EXIST %~1\.git (
	git -C %~1 rev-parse --symbolic-full-name --abbrev-ref @{u} > %TEMP%\temp_remote.txt
	set isGit=1
) ELSE (
	echo.|set /P ="NOT A GIT REPOSITORY" > %TEMP%\temp_remote.txt
	set isGit=0
)
set /p %~2=<%TEMP%\temp_remote.txt
DEL %TEMP%\temp_remote.txt
exit /b

:get_status -- <Folder> <Label> <Include Ignore Print>
setlocal EnableDelayedExpansion
set status=git -C %~1 status -s
IF [%~3] == [0] ( exit /b )
IF [%~3] == [1] ( set exe=!status! --ignored )
!status! > %TEMP%\temp_status.txt
for /f %%t in ("%TEMP%\temp_status.txt") do set size=%%~zt
if !size! GTR 0 (
	call %formatlib% :format_label %~2
	!status!
)
DEL %TEMP%\temp_status.txt
endlocal
exit /b

:get_pull -- <Folder>
call %formatlib% :format_label "Pull"
git -C %~1 pull --prune
exit /b

:get_checkout -- <Folder> <branch>
call %formatlib% :format_label "Checkout"
git -C %~1 checkout -b %~2
exit /b

:get_push -- <Folder> <branch>
call %formatlib% :format_label "Push"
git -C %~1 push -u origin %~2
exit /b