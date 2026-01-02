' CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "wscript.exe ""mic_locker.vbs""", 0, True