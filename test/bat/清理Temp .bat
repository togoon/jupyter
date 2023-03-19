
@rem ----- ExeScript Options Begin -----
@rem ScriptType: console,silent
@rem DestDirectory: D:\My Documents
@rem Icon: 
@rem ----- ExeScript Options End -----
rd /s/q "%userprofile%\Locals~1\temp" & md "%userprofile%\Locals~1\temp"

del /a /f /s /q "%Temp%\*.*"
DEL /F /A /Q  "%temp%\*.*"
RD /S /Q      "%temp%\"
del /a /f /s /q "%Tmp%\*.*"

del /a /f /s /q "%userprofile%\Locals~1\Tempor~1\*.*" 
del /a /f /s /q "%userprofile%\Locals~1\Temp\*.*" 
del /a /f /s /q "%userprofile%\cookies\*.*" 
del /a /f /s /q "%userprofile%\recent\*.*"