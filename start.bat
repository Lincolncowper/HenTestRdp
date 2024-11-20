@echo off
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" >nul 2>&1
net config server /srvcomment:"Windows Server by HenCoders" >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F >nul 2>&1
net user administrator HenCoders13 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
net user installer /delete >nul
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul
bcdedit -set TESTSIGNING OFF >nul 2>&1
echo Instalasi selesai! Jika RDP mati, silakan bangun ulang.
echo IP:
tasklist | find /i "ngrok.exe" >nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Gagal mendapatkan tunnel. Pastikan NGROK_AUTH_TOKEN benar di Settings > Secrets > Repository Secret. Atau mungkin VM sebelumnya masih aktif: https://dashboard.ngrok.com/status/tunnels"
echo Username: administrator
echo Password: HenCoders13
echo Silakan login ke RDP Anda!
echo Komputer akan restart dalam 10 detik...
timeout /t 10 /nobreak >nul
shutdown /r /t 0
