@echo off
echo Menghapus shortcut...
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" >nul 2>&1

echo Mengatur komentar server...
net config server /srvcomment:"Windows Server by HenCoders" >nul 2>&1

echo Menonaktifkan mode tes...
bcdedit -set TESTSIGNING OFF >nul 2>&1

echo Menambahkan user administrator...
net user administrator HenCoders13 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul

echo Menghapus user installer jika ada...
net user installer /delete >nul

echo Mengatur layanan audio...
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

echo Mengatur izin akses...
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

echo Menjalankan ngrok...
if exist "ngrok.exe" (
  tasklist | find /i "ngrok.exe" >nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || (
    echo Gagal mendapatkan tunnel. Pastikan NGROK_AUTH_TOKEN benar dan ngrok berjalan.
    exit /b 1
  )
) else (
  echo ngrok.exe tidak ditemukan!
  exit /b 1
)

echo Instalasi selesai! Jika RDP mati, silakan bangun ulang.
echo IP:
tasklist | find /i "ngrok.exe" >nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Gagal mendapatkan tunnel."

echo Username: administrator
echo Password: HenCoders13
echo Silakan login ke RDP Anda!
