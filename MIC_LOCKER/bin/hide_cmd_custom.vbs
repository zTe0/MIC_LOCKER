' CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "start_lock_mic_vol_CUSTOM.bat", 0, False
