# Promotion de SRV-DC en contrôleur de domaine de aiitops.local
# Ce script redémarre la machine : à lancer AVANT provision_ad.ps1.
# Sans effet si le serveur est déjà contrôleur de domaine.

$DomainName  = "aiitops.local"
$NetBIOS     = "AIITOPS"
$SafeModePwd = ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetBIOS `
  -SafeModeAdministratorPassword $SafeModePwd -InstallDNS -Force
