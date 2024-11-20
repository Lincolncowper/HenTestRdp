@echo off
SET LOGFILE=C:\path\to\logfile.txt
echo ==================================== > %LOGFILE%
echo Starting RDP and Ngrok setup... >> %LOGFILE%
echo ==================================== >> %LOGFILE%

REM Logging Function
:log
echo %1 >> %LOGFILE%
goto :eof

REM Memulai proses setup
call :log "Initializing RDP setup..."

REM Setup RDP (Contoh pengaturan dasar)
call :log "Enabling Remote Desktop..."
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v fDenyTSConnections /t REG_DWORD /d 0 /f
call :log "Remote Desktop enabled."

REM Konfigurasi Firewall untuk RDP
call :log "Configuring firewall for RDP..."
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes
call :log "Firewall configured."

REM Menyiapkan kredensial (gunakan password default untuk Administrator)
call :log "Setting up Administrator password..."
net user Administrator HenCoders
call :log "Administrator password set."

REM Konfigurasi login tanpa password (opsional, hanya jika diperlukan)
call :log "Disabling password expiration for Administrator..."
wmic useraccount where "name='Administrator'" set PasswordExpires=False
call :log "Password expiration disabled for Administrator."

REM Install dan jalankan ngrok
call :log "Starting ngrok setup..."
IF NOT EXIST "C:\Windows\System32\ngrok.exe" (
    call :log "Ngrok not found. Downloading..."
    Invoke-WebRequest -Uri https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip
    Expand-Archive -Path ngrok.zip -DestinationPath ngrok
    move ngrok\ngrok.exe C:\Windows\System32
    call :log "Ngrok installed successfully."
    del ngrok.zip
) ELSE (
    call :log "Ngrok already installed."
)

REM Mengautentikasi ngrok dengan token yang ada
call :log "Authenticating ngrok..."
ngrok authtoken %NGROK_AUTH_TOKEN%
call :log "Ngrok authenticated."

REM Menjalankan ngrok untuk menghubungkan RDP ke public URL
call :log "Starting ngrok tunnel for RDP..."
start ngrok tcp 3389
call :log "Ngrok tunnel started for RDP."

REM Menjaga agar proses tetap berjalan
call :log "Setup complete. Keeping the process running..."
pause

exit /b
