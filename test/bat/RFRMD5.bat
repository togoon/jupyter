
@REM chcp 65001
set rfrPath=c:\notes\bat
set rfrmd5Name=RFRMD5.txt
set rfrmd5fp=%rfrPath%\%rfrmd5Name%

if exist %rfrmd5fp% (
    for /f "tokens=1,2 delims= " %%i in (%rfrmd5fp%) do (
        if exist %rfrPath%\%%j (
            @REM echo %%i %%j
            for /f "skip=1 delims=" %%k in ('certutil -hashfile "%rfrPath%\%%j"  MD5') do (
                if %%i == %%k (
                    @REM call env.bat &  mktimp -i %rfrPath%\%%j
                )
            ) 
        ) else (
            echo Import Error : %rfrPath%\%%j no exist, please check it!
        )
    )
) else (
    echo Import Error : %rfrmd5fp% no exist, please check it!
)