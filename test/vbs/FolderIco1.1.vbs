
' for each arg in Wscript.Arguments
	' wscript.echo arg
' next

Set ws = WScript.CreateObject("wscript.shell")
Set fso = WScript.CreateObject("scripting.filesystemobject")

Dim icoFileName
Dim isExistIco

if (Wscript.Arguments.Count = 1) then
	' wscript.echo Wscript.Arguments.Count
	' mid(str,instrrev(str,"\")+1)   'return upload.exe
	' mid(str,instrrev(str,"\")+1,instrrev(str,".")-instrrev(str,"\")-1)  'return upload
	
	' wscript.echo Wscript.Arguments(0)

	if instrrev(Wscript.Arguments(0),"\") = 0 and (instrrev(Wscript.Arguments(0),"exe") > 0 or instrrev(Wscript.Arguments(0),"ico") > 0 ) then
		exeFolderPath = ws.CurrentDirectory
		icoFileName = Wscript.Arguments(0) 
		Set folder = fso.GetFolder(ws.CurrentDirectory)
		isExistIco = True

	else 
		icoFileName = mid(Wscript.Arguments(0),instrrev(Wscript.Arguments(0),"\")+1)
		exeFolderPath = left(Wscript.Arguments(0),instrrev(Wscript.Arguments(0),"\")-1) 
		Set folder = fso.GetFolder(exeFolderPath)	
		isExistIco = True

	end if

	
	' wscript.echo left(wscript.scriptfullname,instrrev(wscript.scriptfullname,"\")-1) 
else 	
	exeFolderPath = ws.CurrentDirectory
	Set folder = fso.GetFolder(ws.CurrentDirectory)
	Set folderFiles = folder.Files

	for each f in folderFiles
		fileName = f.name
		if LCase(Right(fileName,3))=LCase("ico") then
			' s = s & icoFileName & vbCrLf
			icoFileName = fileName
			isExistIco = True
			exit for
		end if
	next
	
	if not isExistIco then
		for each f in folderFiles
			fileName = f.name
			if LCase(Right(fileName,3))=LCase("exe") then
				' s = s & icoFileName & vbCrLf
				icoFileName = fileName
				isExistIco = True
				exit for
			end if
		next	
	end if
end if

desktopFilePath = exeFolderPath & "\" & "desktop.ini"

' wscript.echo icoFileName
' wscript.echo exeFolderPath
' wscript.echo desktopFilePath

if not isExistIco then
	WScript.quit
end if

Dim MyString
Dim MyArray(3)
MyArray(0) = "[.ShellClassInfo]"
MyArray(1) = "IconFile=" & icoFileName
MyArray(2) = "IconIndex=0"

MyString = Join(MyArray,chr(13)) 

if (fso.fileexists(desktopFilePath)) then
	fso.deleteFile desktopFilePath
end if

' set file = fso.createtextfile( desktopFilePath,True)
set file = fso.OpenTextFile(desktopFilePath,2,True) 
file.writeline MyString
file.close

if (fso.fileexists(desktopFilePath)) then
	
	Set dtfile = fso.GetFile(desktopFilePath)
	dtfile.Attributes = 2	
	
	if (fso.folderExists(exeFolderPath)) then
		
		folder.Attributes = 4	
	end if
	
	' fso.deletefile(wscript.scriptfullname)
end if


