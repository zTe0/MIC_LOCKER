@echo off
echo Check Startup folder: "mic_lock_default"
start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
pause
echo.
echo.
echo Check Start Menu folder: "mic_level"; "mic_killer" 
start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\"
pause
echo.
echo.
echo Check WindowsApps folder: "nircmdc.exe"
start "" "%LocalAppData%\Microsoft\WindowsApps"
pause

@REM set /p choice=Do you wish to delete every file from startup user folder? (y/n):
@REM if /i "%choice%"=="y" (
@REM     echo You chose yes.
@REM     del /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.*"
@REM ) else if /i "%choice%"=="n" (
@REM     echo You chose no.
@REM )
@REM pause


