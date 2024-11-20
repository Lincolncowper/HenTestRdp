@echo off
echo RDP CREATION SUCCESSFUL!

:check
tasklist | find /i "ngrok.exe" >nul
if %errorlevel% neq 0 (
    echo Unable to get NGROK tunnel. Please check NGROK_AUTH_TOKEN in Settings > Secrets > Repository Secret.
    echo Maybe your previous VM is still running: https://dashboard.ngrok.com/status/tunnels
    ping 127.0.0.1 >nul
    exit
)

echo Ngrok tunnel is active.
ping 127.0.0.1 >nul
goto check
