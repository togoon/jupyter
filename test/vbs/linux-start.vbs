Set ws = WScript.CreateObject("WScript.Shell")        
ws.run "wsl -d ubuntu -u root /etc/init.wsl"