
'bat2vbs.vbs by baomaboy
Dim WshSHell,FSO
On Error Resume Next
Set WshSHell = WScript.CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")
Set WinVer = WshSHell.Environment("Process")
Set Args = WScript.Arguments
CloseTime = 5
FileName = WScript.ScriptName
FileFullName = WScript.ScriptFullName
FilePath = FSO.GetParentFolderName(FileFullName)
InsPath = FSO.GetSpecialFolder(1)
InsFullName = FSO.BuildPath(InsPath ,FileName)
LnkPathNT = WshSHell.SpecialFolders(2)
LnkPath9X = WshSHell.SpecialFolders(14)
LnkPathAll = WshSHell.SpecialFolders("SendTo")
OtherFileName="Manage_New.txt"
OtherFilePath=FSO.GetSpecialFolder(2)
TemFileName="Welcome"
TemFilePath=FSO.GetSpecialFolder(2)
Copyright="ation"
Email="Email：ation126@126.com"
InsTitle="Bat2Vbs"
InsAnswer="Bat2Vbs"
RegPath1="HKEY_CLASSES_ROOT\batfile\shell\BatToVbs\"
RegValue1="bat 2 vbs"
RegForm1="REG_SZ"
RegPath2="HKEY_CLASSES_ROOT\batfile\shell\BatToVbs\command\"
RegValue2="wscript.exe " & chr(34) & InsFullName & chr(34) & " " & chr(34) & "%L" & chr(34)
RegForm2="REG_SZ"
IF FileFullName <> InsFullName then
intAnswer = MsgBox("【是】将“"+ InsAnswer +"”加入到右键菜单，"&Chr(10)&Chr(10)&"【否】将“"+ InsAnswer +"”从右键菜单删除。 ", vbQuestion + vbYesNoCancel, "安装 - "+ InsTitle +" - "+ Copyright)
If intAnswer = vbYes Then
WshSHell.RegWrite RegPath1,RegValue1,RegForm1
WshSHell.RegWrite RegPath2,RegValue2,RegForm2
FSO.GetFile(FileFullName).Copy(InsFullName)
WshSHell.popup _
"添加脚本文件："+chr(10)+InsFullName+chr(10)+chr(10)+ _
"添加注册表项："+chr(10)+chr(34)+ RegPath1 +chr(34)+chr(10)+ _
chr(10) & CloseTime & " 秒钟后本窗口将自动关闭!" +chr(10)+chr(10)+ _
chr(10) & "Copyright(C) " + Copyright +" " & QQ &" " + Email _
, CloseTime, "安装成功 - "+ InsTitle +" - "+ Copyright, 0 + 64
end if
If intAnswer = vbNo Then
WshSHell.RegDelete RegPath2
WshSHell.RegDelete RegPath1
FSO.DeleteFile InsFullName
WshSHell.popup _
"删除脚本文件："+chr(10)+InsFullName+chr(10)+chr(10)+ _
"删除注册表项："+chr(10)+chr(34)+ RegPath1 +chr(34)+chr(10)+ _
chr(10) & CloseTime & " 秒钟后本窗口将自动关闭!" +chr(10)+chr(10)+ _
chr(10) & "Copyright(C) " + Copyright +" " & QQ &" " + Email _
, CloseTime, "卸载成功 - "+ InsTitle +" - "+ Copyright, 0 + 64
end if
If intAnswer = vbCancel Then
end if
ELSE
if Args.count=0 then wscript.quit
Set ReadFile = FSO.OpenTextFile(Args(0), 1)
ReadAllText = ReadFile.ReadAll
ReadFile.Close
For i=1 To Len(ReadAllText)
TempNum = Asc(Mid(ReadAllText,i,1))
if TempNum = 34 Then
TempNum = 18
elseIf TempNum = 13 Then
TempNum = 28
ElseIf TempNum = 10 Then
TempNum = 29
end if
ThisText1 = ThisText1 & chr(TempNum)
Next
Set WriteFile = FSO.OpenTextFile(Args(0)&".VBS",2,True)
WriteFile.WriteLine("On Error Resume Next:Dim WshSHell,FSO,Bat2Vbs:Set WshSHell = WScript.CreateObject(""WScript.Shell""):Set FSO = CreateObject(""Scripting.FileSystemObject""):Bat2Vbs="""& ThisText1 &"""")
WriteFile.WriteLine("Execute(""For i=1 To Len(Bat2Vbs)""&vbCrLf&""TempNum = Asc(Mid(Bat2Vbs,i,1))""&vbCrLf&""If TempNum = 28 Then""&vbCrLf&""TempNum = 13""&vbCrLf&""ElseIf TempNum = 29 Then""&vbCrLf&""TempNum = 10""&vbCrLf&""elseif TempNum=18 Then""&vbCrLf&""TempNum = 34""&vbCrLf&""End If""&vbCrLf&""ThisText2 = ThisText2 & chr(TempNum)""&vbCrLf&""Next"")")
WriteFile.WriteLine("Set BatFile = FSO.OpenTextFile(FSO.BuildPath(FSO.GetSpecialFolder(2),""Temp.bat""),2,True):BatFile.WriteLine(ThisText2):BatFile.Close:WshSHell.Run ""%Comspec% /C ""&FSO.BuildPath(FSO.GetSpecialFolder(2),""Temp.bat""),1,false")
WriteFile.Close
end if
Set WshSHell = Nothing
Set FSO = Nothing
Set Args = Nothing
WScript.Quit(0) 