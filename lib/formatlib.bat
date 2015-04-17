@echo off
call :color_init
call:%*
exit /b

::-----------------------------------------------------------------------
::|                          Functions                                  |
::-----------------------------------------------------------------------

:format_label -- <Label>
echo.
call :color 03 "+++ %~1"
echo.
echo.
exit /b

:format_title -- <Title> <Caption> <Width>
setlocal EnableDelayedExpansion
set "space= "
set box=
set spaces=
FOR /L %%c IN (1,1,%~3) DO (
	set box=!box!-
	set spaces=!spaces!!space!
)
set temp_title= %~1 !spaces!
set temp_caption=!spaces! %~2!space!
echo.!box!
call :color 0a "!temp_title:~0,30!"
echo !temp_caption:~-50!
echo.!box!
endlocal
exit /b

:: Below code or ideas are derived from various other peoples work. Originators are unknown -
:: as there are different flavours of the same snippets. All licences however are MIT or Apache 2.0

:color_init
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
exit /b

:color  -- <Color Code> <Label>
setlocal EnableDelayedExpansion
echo.|set /P ="." > X
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
DEL X
endlocal
exit /b