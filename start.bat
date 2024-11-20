@echo off
:: Aktifkan akun Administrator
net user administrator /active:yes >nul 2>&1
:: Tentukan kata sandi yang lebih kompleks dan sesuai kebijakan
net user administrator HenCoders13 /add >nul 2>&1
net localgroup administrators administrator /add >nul 2>&1

:: Menonaktifkan beberapa opsi yang tidak diperlukan
net localgroup "Users" administrator /delete >nul 2>&1

:: Mengonfigurasi agar RDP bisa diakses
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 >nul 2>&1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" >nul 2>&1
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1 >nul 2>&1

:: Mengunduh ngrok dan membuka tunnel
echo Opening ngrok tunnel...
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\ngrok\ngrok.exe tcp --region=ap 3389" 

:: Output informasi login RDP
echo ===================================
echo RDP LOGIN DETAILS
echo ===================================
echo Username: administrator
echo Password: HenCoders13
echo Port: 3389
echo ===================================
