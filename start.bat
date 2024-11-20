@echo off
:: Ensure ngrok is in the system path and the auth token is provided by GitHub Secrets

:: Get the NGROK_AUTH_TOKEN from environment variable
set NGROK_AUTH_TOKEN=%NGROK_AUTH_TOKEN%

:: Check if NGROK_AUTH_TOKEN is set, if not exit
if "%NGROK_AUTH_TOKEN%"=="" (
    echo ERROR: Ngrok auth token is not set.
    exit /b 1
)

:: Set the ngrok path and RDP port
set RDP_PORT=3389
set NGROK_PATH="ngrok.exe"

:: Start ngrok with the provided auth token
start /b %NGROK_PATH% authtoken %NGROK_AUTH_TOKEN%
start /b %NGROK_PATH% tcp %RDP_PORT%

:: Start Remote Desktop (mstsc)
echo "Starting RDP..."
start mstsc /v:localhost:%RDP_PORT%

:: End script
pause
