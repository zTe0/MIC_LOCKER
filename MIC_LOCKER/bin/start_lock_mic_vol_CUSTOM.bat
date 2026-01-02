::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::: Author: Matteo Luciardello Lecardi :::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal enabledelayedexpansion

taskkill /IM "wscript.exe" /F >nul 2>nul
taskkill /IM "nircmdc.exe" /F >nul 2>nul

powershell -NoProfile -ExecutionPolicy Bypass -File GUI_slider.ps1 >nul 2>nul

set /p Volume=<volume.txt
echo %Volume% > current_volume.txt

@REM set /p Volume=Set Volume%% [0-100] and press Enter: 
@REM set "Volume=80"
set /a Volume*=65536
set /a Volume/=100
echo %Volume% > volume.txt
@REM hide_cmd_window2.vbs lock_mic_vol.bat 
@REM start /min /wait wscript.exe "mic_locker.vbs"
@REM wscript.exe "mic_locker.vbs"
wscript.exe "hide_cmd_lock.vbs"
del /F volume.txt >nul 2>nul
@REM taskkill /F /IM cmd.exe >nul 2>nul
@REM taskkill /F /IM conhost.exe /T >nul 2>nul
@REM exit