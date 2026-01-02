' CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = WshShell.CurrentDirectory & "\bin"
WshShell.Run "installer.bat", 0, False
