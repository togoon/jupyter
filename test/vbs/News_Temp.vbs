DIM objShell
set objShell=wscript.createObject("wscript.shell")
iReturn=objShell.Run("cmd.exe /C News_Temp.bat", 0, TRUE)

objShell.run "regsvr32 /s  D:\GSoft\MySoft\Desk\AutoItX3.dll" 
Set au= WScript.CreateObject("AutoItX3.Control")
au.Sleep 1000*6  '����1s

au.MouseClick "left", 1100, 750, 2  '��˫��������ͼ�� ħ���¶ȼ��
'au.send "!{f4}"     '�ر� ���
au.Sleep 1000*1  '����1s

au.MouseClick "left", 350, 750, 1  '���������ͼ�� ħ���ڴ���
au.MouseClick "left", 500, 300, 1  '��� Z��
au.MouseClick "left", 400, 560, 1  '��� ����
au.Sleep 1000*15  '����1s
au.send "!{f4}"     '�ر� ���
