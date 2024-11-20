@echo off
:: Loop to check ngrok status and restart if necessary
:loop
echo Checking ngrok status...

:: Check ngrok status by querying local ngrok API
curl -s http://127.0.0.1:4040/api/tunnels | findstr "tcp://"

:: If ngrok is not running, restart it
if %errorlevel% neq 0 (
    echo Ngrok is down. Restarting ngrok...
    start /b ngrok tcp 3389 --region us
)

:: Wait for 60 seconds before checking again
timeout /t 60
goto loop
