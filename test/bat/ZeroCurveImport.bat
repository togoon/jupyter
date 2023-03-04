@REM chcp 65001
@REM call d:\output\md5env.bat
@REM call d:\sumapps\tools\Orbix63\SummitCs01\orbix633\etc\bin\orbix633_env.bat

@ehco off
@call "D:\summit\SMT\env\etkws_env.bat"

@set rfrPath=d:\input
@set rfrmd5Name=RFRMD5.txt
@set rfrmd5fp=%rfrPath%\%rfrmd5Name%
@set sp= 

@if exist %rfrmd5fp% (
    @for /f "tokens=1,2 delims=%sp%" %%x in (%rfrmd5fp%) do (
        @if exist %rfrPath%\%%y (
            @for /f "tokens=1-16 delims= " %%a in ('certutil -hashfile "%rfrPath%\%%y"  MD5') do (
                @if %%x == %%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p (
					
                    @REM mktimp -i %rfrPath%\%%y
					@echo ---%date% %time%---%%x---333---
					@call choice /t 1 /d y /n >nul
                )
            ) 
        ) else (
            @echo Import Error : %rfrPath%\%%y no exist, please check it!
        )
    )
) else (
    @echo Import Error : %rfrmd5fp% no exist, please check it!
)