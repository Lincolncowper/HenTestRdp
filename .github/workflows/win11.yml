@echo off
net user Administrator /active:yes
net user Administrator HEN2024 /add
net localgroup administrators Administrator /add
net accounts /minpwlen:1 /maxpwage:unlimited /minpwage:1 /passwordchg:yes

diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

echo Successfully Installed, If the RDP is Dead, Please Rebuild Again!
echo IP:
tasklist | find /i "ngrok.exe" >Nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url || echo "Cannot get a tunnel, make sure ngrok_auth_token is correct in Settings> Secrets> Repository Secret. Maybe your previous VM is still running: https://dashboard.ngrok.com/status/tunnels "
echo Username: administrator
echo Password: HEN2024
echo Please log in to your RDP!
ping -n 10 127.0.0.1 >nul
