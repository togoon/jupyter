DIM objShell
set objShell=wscript.createObject("wscript.shell")
iReturn=objShell.Run("cmd.exe /C News_Temp.bat", 0, TRUE)

objShell.run "regsvr32 /s  D:\GSoft\MySoft\Desk\AutoItX3.dll" 
Set au= WScript.CreateObject("AutoItX3.Control")
au.Sleep 1000*6  '休眠1s

au.MouseClick "left", 1100, 750, 2  '左双击任务栏图标 魔方温度监测
'au.send "!{f4}"     '关闭 面板
au.Sleep 1000*1  '休眠1s

au.MouseClick "left", 350, 750, 1  '左击任务栏图标 魔方内存盘
au.MouseClick "left", 500, 300, 1  '左击 Z盘
au.MouseClick "left", 400, 560, 1  '左击 加载
au.Sleep 1000*15  '休眠1s
au.send "!{f4}"     '关闭 面板
