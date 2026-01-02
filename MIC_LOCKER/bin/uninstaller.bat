::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::: Author: Matteo Luciardello Lecardi :::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


@echo off

taskkill /IM "wscript.exe" /F >nul 2>nul
taskkill /IM "nircmdc.exe" /F >nul 2>nul

set "S1=mic_killer.lnk"
set "S2=mic_level.lnk"
set "S3=mic_lock_default.lnk"

del "%S1%" >nul 2>nul
del "..\%S1%" >nul 2>nul
del "%S2%" >nul 2>nul
del "..\%S2%" >nul 2>nul
del "%S3%" >nul 2>nul
del "..\%S3%" >nul 2>nul

set "startup_folder=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup"
set "startmenu_folder=%AppData%\Microsoft\Windows\Start Menu\Programs"

echo %startup_folder%
echo %startmenu_folder%

del "volume_default.txt" >nul 2>nul
del "current_volume.txt" >nul 2>nul
del "%startmenu_folder%\%S1%"
del "%startmenu_folder%\%S2%"
del "%startup_folder%\%S3%"

set "install_path=%LocalAppData%\Microsoft\WindowsApps"
del "%install_path%\nircmdc.exe" >nul 2>nul
