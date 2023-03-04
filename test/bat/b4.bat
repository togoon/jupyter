@echo off
certutil -hashfile "c:\notes\bat\RFRHO.txt" MD5  

echo  %date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%


rem @echo off
set "$=%temp%\Spring">%$% Echo WScript.Echo((new Date()).getTime())
for /f %%a in ('cscript -nologo -e:jscript %$%') do set timestamp=%%a
rem del /f /q %$%
echo %timestamp%


echo %time%

echo %date% %time%




