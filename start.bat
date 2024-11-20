@echo off

:: Menghapus shortcut default
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1

:: Mengatur komentar server
net config server /srvcomment:"Windows Server 2016 by HenCoders" > out.txt 2>&1

:: Mengatur registry untuk menonaktifkan auto tray dan menambahkan startup
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat > out.txt 2>&1

:: Mengatur user administrator
net user administrator HenCoders2024 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
net user installer /delete >nul

:: Mengoptimalkan sistem dan layanan
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

:: Mengatur izin akses untuk folder penting
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

:: Menyiapkan ngrok
echo Mengunduh dan menjalankan ngrok...
set NGROK_URL=https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip
set NGROK_ZIP=ngrok.zip
set NGROK_EXE=ngrok.exe

curl -L -o %NGROK_ZIP% %NGROK_URL%
if exist %NGROK_ZIP% (
    tar -xf %NGROK_ZIP% >nul 2>&1 || powershell -Command "Expand-Archive -Force %NGROK_ZIP% ."
    del %NGROK_ZIP%
) else (
    echo Gagal mengunduh ngrok. Periksa koneksi internet Anda.
    exit /b 1
)

if not exist %NGROK_EXE% (
    echo ngrok.exe tidak ditemukan setelah unduhan. Periksa ZIP atau proses ekstraksi.
    exit /b 1
)

:: Menjalankan ngrok
start "" "%CD%\ngrok.exe" http 80 >nul 2>&1
timeout /t 3 >nul

:: Menampilkan status instalasi
echo Successfully Installed, If the RDP is Dead, Please Rebuild Again!
echo IP:
tasklist | find /i "ngrok.exe" >nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Cannot get a tunnel, make sure NGROK_AUTH_TOKEN is correct in Settings > Secrets > Repository Secret. Maybe your previous VM is still running: https://dashboard.ngrok.com/status/tunnels"
echo Username: administrator
echo Password: HenCoders2024
echo Please log in to your RDP!

:: Menunda sebelum reboot
ping -n 10 127.0.0.1 >nul
shutdown /r /t 0
