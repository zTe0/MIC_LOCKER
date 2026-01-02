Set objShell = WScript.CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile("volume.txt", 1)
raw = file.ReadAll

file.Close
' fso.DeleteFile("volume.txt")

volume = ""
For i = 1 To Len(raw)
    ch = Mid(raw, i, 1)
    If ch >= "0" And ch <= "9" Then
        volume = volume & ch
    End If
Next

cmd = "nircmdc loop 172800 500 setsysvolume " & volume & " default_record"
If IsNumeric(volume) Then
    objShell.Run cmd, 0, False
Else 
    objShell.Run("nircmdc loop 172800 500 setsysvolume 65536 default_record"), 0, False
End If