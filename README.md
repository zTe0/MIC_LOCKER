# MIC_LOCKER
This software is intented to lock the desired level of microphone in win10 and 11, which is not possible by default.
INSTALLATION:

0.A) 7-ZIP INSTALLATION IS REQUIRED (preferably this path shall exist C:\Program Files\7-Zip\7z.exe)

0.B) run "folders_check.bat" to open startup folder and delete all unwanted files

1) run installer.vbs

2) choose whether to add shortcuts to start menu and/or startup folders (startup setup is recommended)

3) use the slider to choose the default value that will be run at startup (this is also being set immediately)

4) place the 3 shortcuts where you wish

EXECUTION:

-run "mic_killer" to stop the process (start menu, running in /bin/killer.bat) --> use this file to fix most of issues

-run "mic_level" to customize the desired value with the slider [0-100] (start menu, running /bin/start_lock_mic_vol_CUSTOM.bat)

-run "lock_mic_default" to set the default value chosen during installation, fixed at startup, default: 80 (startup folder, running /bin/start_lock_mic_vol_DEFAULT.bat)

-run "installer.vbs" to reset the default value

-run "uninstaller.vbs" to delete all shortcuts from launch folder, /bin/, startup and start menu

-in case of any issues (icons not showing, cmd window not minimizing, MIC LEVEL bugs), it is recommended to run mic_killer, uninstaller, installer

Based on...
NirCmd v2.75 (Console Version)
Copyright (c) 2003 - 2013 Nir Sofer

icons from:
https://www.flaticon.com/
