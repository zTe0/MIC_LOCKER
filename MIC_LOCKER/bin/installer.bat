::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::: Author: Matteo Luciardello Lecardi :::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

if not exist "current_volume.txt" (
    echo 85 > current_volume.txt
)

set "install_path=%LocalAppData%\Microsoft\WindowsApps"
copy "nircmdc.exe" "%install_path%\nircmdc.exe" >nul 2>nul

powershell -NoProfile -ExecutionPolicy Bypass -File installer.ps1 >nul 2>nul

powershell -NoProfile -ExecutionPolicy Bypass -File GUI_slider.ps1 >nul 2>nul

del "volume_default.txt" >nul 2>nul
start_lock_mic_vol_DEFAULT.bat