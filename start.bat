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

:: Unduh ngrok
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

:: Jalankan ngrok
start "" "%CD%\ngrok.exe" tcp 3389 >ngrok.log 2>&1
timeout /t 3 >nul

:: Periksa ngrok
tasklist | find /i "ngrok.exe" >nul
if %errorlevel% equ 0 (
    for /f "tokens=2 delims=:" %%i in ('curl -s localhost:4040/api/tunnels ^| findstr "tcp://0"') do set TUNNEL=%%i
    echo IP: tcp://%TUNNEL%
) else (
    echo Gagal mendapatkan URL ngrok. Periksa log atau coba lagi.
)

:: Menampilkan kredensial RDP
echo Username: administrator
echo Password: HenCoders2024
echo Please log in to your RDP!

:: Menunda sebelum reboot
ping -n 10 127.0.0.1 >nul
shutdown /r /t 0
