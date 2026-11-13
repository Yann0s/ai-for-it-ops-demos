@echo off
REM =========================================================
REM Post-install pour SRV-DC (Windows Server 2022)
REM Exécuté automatiquement par Dockur après l'installation.
REM Active WinRM, OpenSSH, RDP et configure le pare-feu.
REM =========================================================

echo [install.bat] Demarrage de la configuration post-install...

REM ── Config IP statique (redondant avec les vars d'env Dockur, sécurité) ──
echo [install.bat] Configuration reseau statique...
netsh interface ip set address "Ethernet" static 192.168.10.241 255.255.255.0 192.168.10.254
netsh interface ip set dns "Ethernet" static 192.168.10.254 primary

REM ── WinRM (PowerShell Remoting) ──
echo [install.bat] Activation de WinRM...
powershell -Command "Enable-PSRemoting -Force" >nul 2>&1
powershell -Command "Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*' -Force" >nul 2>&1
netsh advfirewall firewall add rule name="WinRM HTTP" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM HTTPS" protocol=TCP dir=in localport=5986 action=allow

REM ── OpenSSH Server ──
echo [install.bat] Installation de OpenSSH Server...
powershell -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0" >nul 2>&1
powershell -Command "Start-Service sshd" >nul 2>&1
powershell -Command "Set-Service -Name sshd -StartupType 'Automatic'" >nul 2>&1
netsh advfirewall firewall add rule name="OpenSSH" protocol=TCP dir=in localport=22 action=allow

REM ── RDP ──
echo [install.bat] Activation du Bureau a distance...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes
netsh advfirewall firewall add rule name="RDP" protocol=TCP dir=in localport=3389 action=allow

REM ── Ping (ICMP) ──
echo [install.bat] Autorisation ICMP (ping)...
netsh advfirewall firewall add rule name="ICMP Allow" protocol=icmpv4:8,any dir=in action=allow

REM ── PowerShell ExecutionPolicy ──
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force" >nul 2>&1

REM ── Créer le disque E: pour les partages ──
echo [install.bat] Creation du disque E: pour les partages...
powershell -Command "Initialize-Disk -Number 1 -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Shares' -Confirm:$false" >nul 2>&1

REM ── Désactiver l'UAC (lab, pas prod) ──
echo [install.bat] Desactivation UAC pour le lab...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

echo [install.bat] Configuration terminee. Redemarrage...
shutdown /r /t 10 /c "install.bat: redemarrage post-configuration"