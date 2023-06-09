@echo off
@ ECHO.
echo ******************************************
echo ATion 制作 欢迎您来做客
echo.
echo 正在清除系统垃圾文件，请稍等...... 
echo ******************************************
@ ECHO.
@ ECHO.                              说    明
@ ECHO -----------------------------------------------------------------------
@ ECHO 这是网上流传的批处理。它会帮您删除回收站、临时目录、最近打开过的文档痕迹
@ ECHO 等。对系统运行会有帮助。如果你电脑运行速度很慢，是因为是因为太多无用的运
@ ECHO 算占据了CPU和内存资源所致。重做系统或用Ghost恢复系统是最彻底的办法。
@ ECHO 
@ ECHO -----------------------------------------------------------------------
@ ECHO      
@ ECHO 
@ ECHO                           
@ ECHO    
@ ECHO                    
@ ECHO           
@ ECHO                    
@ ECHO.
@echo off
::修正于2008-07-29
color 2f
Title 系统垃圾文件清理器 
echo.
echo  *****  系统垃圾文件清理器  *****
echo          
echo.
echo  本程序特点：
echo      鉴于很多人把IE缓存等文件夹转移到非系统盘，
echo  所以，本程序清理垃圾文件时，首先进行判断系统
echo  的设置。
echo.
echo  优点：清理位置更加准确，策略更加科学。
echo.
echo  开始执行清理……
echo.

echo 正在检查cookies、历史纪录等目录位置(当前用户)……

del /a /f /s /q "C:\Users\ATi\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"

reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Cache>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Cookies>>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v History>>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v NetHood>>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Recent>>%temp%\cleantmp.txt


echo 正在清理Cookies、IE缓存、历史纪录等(当前用户)……
for /f "tokens=3*" %%a in (%temp%\cleantmp.txt) do (
  for /d %%i in ("%%a %%b\*.*") do rd /s /q "%%i"
  del /a /f /s /q "%%a %%b\*.*"
)
::跟上面几项未必是重复的(！)，也是对当前用户目录

echo 正在清理临时文件 (系统目录)……

del /a /f /s /q "%userprofile%\Locals~1\Tempor~1\*.*" 
del /a /f /s /q "%userprofile%\Locals~1\Temp\*.*" 
del /a /f /s /q "%userprofile%\cookies\*.*" 
del /a /f /s /q "%userprofile%\recent\*.*"
del /a /f /s /q "%Temp%\*.*"
DEL /F /A /Q  "%temp%\*.*"
RD /S /Q      "%temp%\"
del /a /f /s /q "%Tmp%\*.*"
del /a /f /s /q "%HomePath%\..\IconCache.db"
rd /s /q %windir%\temp & md %windir%\temp
Deltree /y %windir%\temp & md %windir%\temp
Deltree /y "%userprofile%\Locals~1\temp 
md "%userprofile%\Locals~1\temp

echo 正在清理系统目录中的垃圾文件 (稍候，需要点时间)……

del /a /f /s /q "%SystemRoot%\*._mp"
del /a /f /s /q "%SystemRoot%\*.bak"
del /a /f /s /q "%SystemRoot%\*.log"
del /a /f /s /q "%SystemRoot%\*.dmp"
del /a /f /s /q "%SystemRoot%\*.gid"
del /a /f /s /q "%SystemRoot%\*.old"
del /a /f /s /q "%SystemRoot%\*.query"
del /a /f /q    "%SystemRoot%\*.tmp"

rd /s /q "%SystemRoot%\Downloaded Program Files"
rd /s /q "%SystemRoot%\Offline Web Pages"
rd /s /q "%systemroot%\Connection Wizard"
rd /s /q "%SystemRoot%\SoftwareDistribution\Download"
rd /s /q "%SystemRoot%\Assembly"
rd /s /q "%SystemRoot%\Help"
rd /s /q "%SystemRoot%\ReinstallBackups"

del /a /s /q "%SystemRoot%\inf\*.pnf"
del /a /f /s /q "%SystemRoot%\inf\InfCache.1"
dir %SystemRoot%\inf\*.* /ad/b >%SystemRoot%\vTmp.txt
for /f %%a in (%SystemRoot%\vTmp.txt) do rd /s /q "%SystemRoot%\inf\%%a"
del /a /f /s /q "%SystemRoot%\driver?\*.pnf"
del /a /f /s /q "%SystemRoot%\driver?\InfCache.1" 
del /a /f /s /q "%SystemDrive%\driver?\*.pnf"
del /a /f /s /q "%SystemDrive%\driver?\InfCache.1"
rd /s /q "%SystemRoot%\temp" & md "%SystemRoot%\temp"
del /a /f /s /q "%SystemRoot%\Prefetch\*.*"
del /a /f /s /q "%SystemRoot%\minidump\*.*"

echo 正在清除无用的磁盘检错文件 (系统分区)……

del /a /f /q "%SystemDrive%\*.chk"
dir %SystemDrive%\found.??? /ad/b >%SystemRoot%\vTmp.txt
for /f %%a in (%SystemRoot%\vTmp.txt) do rd /s /q "%SystemDrive%\%%a"

echo 正在清理系统升级补丁留下来的反安装目录 (已修正能正确清除)……

dir %SystemRoot%\$*$ /ad/b >%SystemRoot%\vTmp.txt
for /f %%a in (%SystemRoot%\vTmp.txt) do rd /s /q "%SystemRoot%\%%a"

echo 正在清除常见的软件垃圾项目 (按默认目录)……

rd /s /q "%ProgramFiles%\InstallShield Installation Information"
Ren "%ProgramFiles%\Common~1\Real\Update_OB\realsched.exe" realsched.ex_
Del "%ProgramFiles%\Common~1\Real\Update_OB\realsched.exe"
Reg Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v TkBellExe /f
rd /s /q "%ProgramFiles%\Tencent\QQGame\Download"
taskkill /f /im "TIMPlatform.exe" /t
del /a /f /s /q "%ProgramFiles%\Tencent\QQ\TIMPlatform.exe"
del /a /f /s /q "%ProgramFiles%\Kaspersky Lab\*.tmp"
echo.

echo 正在清除注册表HKCU_Run项……

reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v  WallPaperMonthlyCalendar /f

echo  全部清理完毕，任意键退出 (注: 若提示文件没找到是正常的)……

del %SystemRoot%\vTmp.txt

Deltree /y "%userprofile%\Locals~1\temp" & md "%userprofile%\Locals~1\temp"

del /a /f /s /q "%Temp%\*.*"
DEL /F /A /Q  "%temp%\*.*"
RD /S /Q      "%temp%\"
del /a /f /s /q "%Tmp%\*.*"

del /a /f /s /q "%userprofile%\Locals~1\Tempor~1\*.*" 
del /a /f /s /q "%userprofile%\Locals~1\Temp\*.*" 
del /a /f /s /q "%userprofile%\cookies\*.*" 
del /a /f /s /q "%userprofile%\recent\*.*"
del /a /f /s /q "C:\Documents and Settings\All Users\Application Data\mcache\*.*"




echo ******************************************
echo ATion 制作 欢迎您来做客
echo pause 
echo 清除系统垃圾完成！ 
echo ******************************************
