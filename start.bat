@echo off
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Server by HenCoders" > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat > out.txt 2>&1
net user administrator HenCoders13 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
net user installer /delete >nul
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

:: Menonaktifkan "Test Mode" di kanan bawah
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ShowUserInfoAtLockScreen /t REG_DWORD /d 0 /f > nul
bcdedit -set testsigning off

echo Instalasi Berhasil, Jika RDP Tidak Berfungsi, Silakan Bangun Kembali!
echo IP:
tasklist | find /i "ngrok.exe" >Nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Tidak dapat mendapatkan terowongan, pastikan ngrok_auth_token sudah benar di Pengaturan > Secrets > Repository Secret. Mungkin VM Anda sebelumnya masih berjalan: https://dashboard.ngrok.com/status/tunnels "
echo Username: administrator
echo Password: HenCoders13
echo Silakan login ke RDP Anda!
ping -n 10 127.0.0.1 >nul
