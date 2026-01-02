' CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "killer.bat", 0, False
