@echo off
:: Menghapus shortcut Epic Games Launcher jika ada
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1

:: Menambahkan komentar ke server
net config server /srvcomment:"Windows Server by HenCoders" > out.txt 2>&1

:: Mengatur registry untuk menonaktifkan tray otomatis
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1

:: Menambahkan entri ke registry untuk menjalankan wallpaper.bat, jika diperlukan
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat > out.txt 2>&1

:: Menambahkan user "administrator" dengan kata sandi dan mengaktifkannya
net user administrator HenCoders13 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul

:: Menghapus user "installer"
net user installer /delete >nul

:: Mengonfigurasi disk dan layanan audio
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

:: Mengatur izin akses pada folder sementara dan installer
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

:: Menampilkan pesan bahwa instalasi berhasil dan menunggu informasi IP
echo Successfully Installed, If the RDP is Dead, Please Rebuild Again!
echo IP:
tasklist | find /i "ngrok.exe" >Nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Cannot get a tunnel, make sure ngrok_auth_token is correct in Settings> Secrets> Repository Secret. Maybe your previous VM is still running: https://dashboard.ngrok.com/status/tunnels"

:: Menampilkan informasi login RDP
echo Username: administrator
echo Password: HenCoders13
echo Please log in to your RDP!

:: Menunggu 10 detik agar RDP dapat digunakan
ping -n 10 127.0.0.1 >nul
