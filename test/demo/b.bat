　　@echo off
　　set str1=abcd1233
　　set str2=ABCD1234
　　if %str1%==%str2% (echo 字符串相同！) else (echo 字符串不相同！)


　　@echo off
　　if exist %0 echo 文件%0是存在的！
　　if not exist %~df0 (
　　echo 文件夹%~df0不存在！
　　) else echo 文件夹%~df0存在！
　　pause>nul



certutil -hashfile %arg1% MD5 | find /v ":" > %arg2%.md5


rem 先读取旧的md5值
if exist %arg2%.md5 (set /p md5_old=<%arg2%.md5)


@echo off
rem 获取文件xx.zip的MD5
for /f "delims=" %%i in ('md5.exe xx.zip') do (set md5_var=%%i)
echo %md5_var%

::从文件获取MD5 格式MD5=xxxxxxxxxxxxxx
::tokens表示demlims后第一个符号分割的列号
for /f "tokens=2 delims==" %%i in (1.txt) do (
echo %%i|findstr "="

set md5_provide=%%i)
echo %md5_provide%

if "%md5_var%" == "%md5_provide%" (
    echo success
) else (
    echo error %md5_var%
)
pause > nul



：：：：：：：：：：：：：：：：：：：：：：：：


@echo off & setlocal

rem 参数去引号处理
set arg1=%~1
set arg2=%~2

rem arg1文件路径不能为空
if "%arg1%"=="" goto usage
if not exist %arg1% goto usage

rem arg2 md5临时文件名，为空默认为文件名.md5
if "%arg2%"=="" set arg2=%arg1%

rem 先读取旧的md5值
if exist %arg2%.md5 (set /p md5_old=<%arg2%.md5)

rem 计算文件md5值，保存到md5文件
certutil -hashfile %arg1% MD5 | find /v ":" > %arg2%.md5

rem 读取新的md5值
set /p md5=<%arg2%.md5
set flag=0

rem 比较md5值是否变化，判断文件是否发生变化
if defined md5_old (
    if not "%md5_old%" == "%md5%" ( set flag=1 )
)

rem 输出1文件发生变化，0文件没发生变化
echo %flag%
exit /b 0

:usage
echo %0 filepath [md5name]
exit /b 1


：：：：：：：：：：：：：：：：：：：：：：：：


@echo off
set input=%1
certutil -hashfile %input% MD5
pause
 

保存为 MD5.bat
找到要计算md5的文件拖入 MD5.bat 文件即可查询


：：：：：：：：：：：：：：：：：：：：：：：：


bat文件逐行读取txt
From_Ip='192.138.60.16'
@echo off
for /f "tokens=1,2 delims='" %%a in (D:\ETL\bat\config.txt) do (
if "%%a"=="From_Ip=" set From_Ip=%%b
)
echo %From_Ip%    结果：192.138.60.16

：：：：：：：：：：：：：：：：：：：：：：：：


@echo off

for /f "delims=: tokens=1,2*" %%i in ('type a.txt ^| findstr /n .*') do set abc%%i=%%j

set abc

pause

：：：：：：：：：：：：：：：：：：：：：：：：


for /f "delims=" %%i in (data.txt) do (
call data.bat %%i_996
)

@echo off & setlocal enabledelayedexpansion
set aa=0
for /f "eol=/delims=" %%b in (1.txt) do (
    echo %%b
    set /a "bds[!aa!] = %%b",aa=aa+1
    echo !aa!
) 



@echo off
echo %1
if "%1"=="ker" ( 
 echo kernel
 echo kernel2
 echo kernel3
) else (
 echo dtbc
 echo dtbc1
 echo dtbc2
 echo dtbc3
