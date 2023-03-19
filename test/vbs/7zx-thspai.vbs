
DIM objShell
DIM filePath, fileName, dateTime, strCommand, mutliFilePath

mutliFilePath = ""

Set args = WScript.Arguments
If args.Count >= 1 Then
	filePath = WScript.Arguments.Item(0)

	for each i in args
		mutliFilePath = mutliFilePath &Chr(34) &i &Chr(34) &" "
	next
End If

Function getName(strPathName)
	If instrrev(strPathName,".") = 0 Then
		getName = Right(strPathName, Len(strPathName) -instrrev(strPathName,"\") )
	Elseif instrrev(strPathName,".") < instrrev(strPathName,"\") Then
		getName = Mid(strPathName, instrrev(strPathName,"\")+1, Len(strPathName)-instrrev(strPathName,"\"))
	Else
		getName = Mid(strPathName, instrrev(strPathName,"\")+1, instrrev(strPathName,".")-instrrev(strPathName,"\")-1)
	End If
	
End Function 

Function getFold(strPathName)
	getFold = Left(strPathName, instrrev(strPathName,"\")-1 )
End Function 

dateTime = CStr(Year(Now()))&Right("0"&Month(Now()),2)&Right("0"&Day(Now()),2)&Right("0"&Hour(Now()),2)&Right("0"&Minute(Now()),2)&Right("0"&Minute(Now()),2)

' WScript.Echo filePath
' WScript.Echo mutliFilePath

fileName = getFold(filePath) &"\" & Replace( getName(filePath) ," ","_") &"_" &dateTime

set objShell = wscript.createObject("wscript.shell")

strCommand = Chr(34) &"D:\GSoft\MySoft\7-Zip64\7z.exe" &Chr(34) &" a -t7z " &Chr(34) &fileName &".7z" &Chr(34) &" -pThs314159 "  &mutliFilePath 

' WScript.Echo strCommand

iReturn = objShell.Run(strCommand, 0, TRUE)
