# AD Seed pour aiitops.local — généré avec SEED=42
# Ce script crée la forêt, les OUs, utilisateurs, groupes et partages.

$DomainName = "aiitops.local"
$NetBIOS   = "AIITOPS"
$SafeModePwd = ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force

# ── Installer AD DS + créer la forêt ──
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetBIOS -SafeModeAdministratorPassword $SafeModePwd -InstallDNS -Force

# ── OUs ──
New-ADOrganizationalUnit -Name "TN" -Path "DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Groupes" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Serveurs" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Ordinateurs" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Stagiaires" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Comptes_de_service" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Direction" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "DSI" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "RH" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Comptabilité" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Commercial" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Production" -Path "OU=TN,DC=aiitops,DC=local" -ProtectedFromAccidentalDeletion $false

# ── Utilisateurs ──
New-ADUser -Name "Pauline Garcia" -SamAccountName "pgarcia" -UserPrincipalName "pgarcia@aiitops.local" -GivenName "Pauline" -Surname "Garcia" -Title "Directeur Général" -Department "Direction" -Path "OU=Direction,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\pgarcia" -OfficePhone "+33148872246" -Office "A-1007"
New-ADUser -Name "Charlotte Bernard" -SamAccountName "cbernard" -UserPrincipalName "cbernard@aiitops.local" -GivenName "Charlotte" -Surname "Bernard" -Title "Assistante de Direction" -Department "Direction" -Path "OU=Direction,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\cbernard" -OfficePhone "+33145329258" -Office "A-1009"
New-ADUser -Name "Mathieu Roux" -SamAccountName "mroux" -UserPrincipalName "mroux@aiitops.local" -GivenName "Mathieu" -Surname "Roux" -Title "Tech Support" -Department "DSI/Infrastructure" -Path "OU=Infrastructure,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\mroux" -OfficePhone "+33191106814" -Office "A-4006"
New-ADUser -Name "Romane Moreau" -SamAccountName "rmoreau" -UserPrincipalName "rmoreau@aiitops.local" -GivenName "Romane" -Surname "Moreau" -Title "Admin Système" -Department "DSI/Infrastructure" -Path "OU=Infrastructure,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\rmoreau" -OfficePhone "+33153900581" -Office "B-1002"
New-ADUser -Name "Yasmine Petit" -SamAccountName "ypetit" -UserPrincipalName "ypetit@aiitops.local" -GivenName "Yasmine" -Surname "Petit" -Title "Admin Réseau" -Department "DSI/Infrastructure" -Path "OU=Infrastructure,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\ypetit" -OfficePhone "+33162988662" -Office "B-3001"
New-ADUser -Name "Chloé Martinez" -SamAccountName "cmartine" -UserPrincipalName "cmartine@aiitops.local" -GivenName "Chloé" -Surname "Martinez" -Title "Ingénieur Cloud" -Department "DSI/Infrastructure" -Path "OU=Infrastructure,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\cmartine" -OfficePhone "+33174230889" -Office "B-1009"
New-ADUser -Name "Lucas Robert" -SamAccountName "lrobert" -UserPrincipalName "lrobert@aiitops.local" -GivenName "Lucas" -Surname "Robert" -Title "Support N2" -Department "DSI/Support" -Path "OU=Support,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\lrobert" -OfficePhone "+33142793384" -Office "A-3002"
New-ADUser -Name "Olivier Petit" -SamAccountName "opetit" -UserPrincipalName "opetit@aiitops.local" -GivenName "Olivier" -Surname "Petit" -Title "Support N1" -Department "DSI/Support" -Path "OU=Support,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\opetit" -OfficePhone "+33164391476" -Office "B-3003"
New-ADUser -Name "Xavier Andre" -SamAccountName "xandre" -UserPrincipalName "xandre@aiitops.local" -GivenName "Xavier" -Surname "Andre" -Title "Responsable Support" -Department "DSI/Support" -Path "OU=Support,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\xandre" -OfficePhone "+33153802729" -Office "B-1003"
New-ADUser -Name "Inès David" -SamAccountName "idavid" -UserPrincipalName "idavid@aiitops.local" -GivenName "Inès" -Surname "David" -Title "Support N3" -Department "DSI/Support" -Path "OU=Support,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\idavid" -OfficePhone "+33150584714" -Office "B-3009"
New-ADUser -Name "Nicolas Morel" -SamAccountName "nmorel" -UserPrincipalName "nmorel@aiitops.local" -GivenName "Nicolas" -Surname "Morel" -Title "Développeur Full-Stack" -Department "DSI/Développement" -Path "OU=Développement,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\nmorel" -OfficePhone "+33153787277" -Office "B-4008"
New-ADUser -Name "Jean Bertrand" -SamAccountName "jbertran" -UserPrincipalName "jbertran@aiitops.local" -GivenName "Jean" -Surname "Bertrand" -Title "DevOps" -Department "DSI/Développement" -Path "OU=Développement,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\jbertran" -OfficePhone "+33148358607" -Office "C-3007"
New-ADUser -Name "Mathieu Dupont" -SamAccountName "mdupont" -UserPrincipalName "mdupont@aiitops.local" -GivenName "Mathieu" -Surname "Dupont" -Title "Développeur Frontend" -Department "DSI/Développement" -Path "OU=Développement,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\mdupont" -OfficePhone "+33163329974" -Office "A-4002"
New-ADUser -Name "Delphine Durand" -SamAccountName "ddurand" -UserPrincipalName "ddurand@aiitops.local" -GivenName "Delphine" -Surname "Durand" -Title "Développeur Frontend" -Department "DSI/Développement" -Path "OU=Développement,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\ddurand" -OfficePhone "+33149757924" -Office "A-4002"
New-ADUser -Name "Yasmine Mercier" -SamAccountName "ymercier" -UserPrincipalName "ymercier@aiitops.local" -GivenName "Yasmine" -Surname "Mercier" -Title "Lead Dev" -Department "DSI/Développement" -Path "OU=Développement,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\ymercier" -OfficePhone "+33178590785" -Office "C-3009"
New-ADUser -Name "Antoine Durand" -SamAccountName "adurand" -UserPrincipalName "adurand@aiitops.local" -GivenName "Antoine" -Surname "Durand" -Title "Lead Dev" -Department "DSI/Développement" -Path "OU=Développement,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\adurand" -OfficePhone "+33183663054" -Office "B-3002"
New-ADUser -Name "Chloé Bertrand" -SamAccountName "cbertran" -UserPrincipalName "cbertran@aiitops.local" -GivenName "Chloé" -Surname "Bertrand" -Title "Chargé de recrutement" -Department "RH" -Path "OU=RH,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\cbertran" -OfficePhone "+33172898975" -Office "A-1005"
New-ADUser -Name "Stéphanie Chevalier" -SamAccountName "schevali" -UserPrincipalName "schevali@aiitops.local" -GivenName "Stéphanie" -Surname "Chevalier" -Title "Responsable RH" -Department "RH" -Path "OU=RH,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\schevali" -OfficePhone "+33178308573" -Office "A-3003"
New-ADUser -Name "Inès Blanc" -SamAccountName "iblanc" -UserPrincipalName "iblanc@aiitops.local" -GivenName "Inès" -Surname "Blanc" -Title "Gestionnaire RH" -Department "RH" -Path "OU=RH,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\iblanc" -OfficePhone "+33198100599" -Office "C-3008"
New-ADUser -Name "Laura Richard" -SamAccountName "lrichard" -UserPrincipalName "lrichard@aiitops.local" -GivenName "Laura" -Surname "Richard" -Title "Contrôleur de Gestion" -Department "Comptabilité" -Path "OU=Comptabilité,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\lrichard" -OfficePhone "+33145867460" -Office "B-1009"
New-ADUser -Name "Isabelle Leroy" -SamAccountName "ileroy" -UserPrincipalName "ileroy@aiitops.local" -GivenName "Isabelle" -Surname "Leroy" -Title "Chef Comptable" -Department "Comptabilité" -Path "OU=Comptabilité,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\ileroy" -OfficePhone "+33182598369" -Office "C-2005"
New-ADUser -Name "Henri Bonnet" -SamAccountName "hbonnet" -UserPrincipalName "hbonnet@aiitops.local" -GivenName "Henri" -Surname "Bonnet" -Title "Assistant Comptable" -Department "Comptabilité" -Path "OU=Comptabilité,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\hbonnet" -OfficePhone "+33153665492" -Office "C-2005"
New-ADUser -Name "Zacharie Lefevre" -SamAccountName "zlefevre" -UserPrincipalName "zlefevre@aiitops.local" -GivenName "Zacharie" -Surname "Lefevre" -Title "Comptable" -Department "Comptabilité" -Path "OU=Comptabilité,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\zlefevre" -OfficePhone "+33168642717" -Office "B-1004"
New-ADUser -Name "Antoine Robert" -SamAccountName "arobert" -UserPrincipalName "arobert@aiitops.local" -GivenName "Antoine" -Surname "Robert" -Title "Chargé de Clientèle" -Department "Commercial" -Path "OU=Commercial,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\arobert" -OfficePhone "+33185761759" -Office "A-2002"
New-ADUser -Name "Charlotte Girard" -SamAccountName "cgirard" -UserPrincipalName "cgirard@aiitops.local" -GivenName "Charlotte" -Surname "Girard" -Title "Commercial Sédentaire" -Department "Commercial" -Path "OU=Commercial,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\cgirard" -OfficePhone "+33144639131" -Office "A-3008"
New-ADUser -Name "Nicolas Rousseau" -SamAccountName "nroussea" -UserPrincipalName "nroussea@aiitops.local" -GivenName "Nicolas" -Surname "Rousseau" -Title "Responsable Commercial" -Department "Commercial" -Path "OU=Commercial,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\nroussea" -OfficePhone "+33148858490" -Office "C-4004"
New-ADUser -Name "Élodie Lambert" -SamAccountName "élambert" -UserPrincipalName "élambert@aiitops.local" -GivenName "Élodie" -Surname "Lambert" -Title "Responsable Commercial" -Department "Commercial" -Path "OU=Commercial,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\élambert" -OfficePhone "+33152198907" -Office "A-4006"
New-ADUser -Name "Chloé Girard" -SamAccountName "cgirard1" -UserPrincipalName "cgirard1@aiitops.local" -GivenName "Chloé" -Surname "Girard" -Title "Designer UX" -Department "Production" -Path "OU=Production,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\cgirard1" -OfficePhone "+33191214576" -Office "A-2004"
New-ADUser -Name "Inès Francois" -SamAccountName "ifrancoi" -UserPrincipalName "ifrancoi@aiitops.local" -GivenName "Inès" -Surname "Francois" -Title "Product Manager" -Department "Production" -Path "OU=Production,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\ifrancoi" -OfficePhone "+33148542374" -Office "A-3008"
New-ADUser -Name "Pauline Robert" -SamAccountName "probert" -UserPrincipalName "probert@aiitops.local" -GivenName "Pauline" -Surname "Robert" -Title "Designer UI" -Department "Production" -Path "OU=Production,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\probert" -OfficePhone "+33168947272" -Office "C-1001"
New-ADUser -Name "Thierry Rousseau" -SamAccountName "troussea" -UserPrincipalName "troussea@aiitops.local" -GivenName "Thierry" -Surname "Rousseau" -Title "Scrum Master" -Department "Production" -Path "OU=Production,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\troussea" -OfficePhone "+33193115474" -Office "A-2003"
New-ADUser -Name "Amélie Garnier" -SamAccountName "agarnier" -UserPrincipalName "agarnier@aiitops.local" -GivenName "Amélie" -Surname "Garnier" -Title "Chef de Projet" -Department "Production" -Path "OU=Production,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\agarnier" -OfficePhone "+33170324130" -Office "B-1003"
New-ADUser -Name "Quentin Martinez" -SamAccountName "qmartine" -UserPrincipalName "qmartine@aiitops.local" -GivenName "Quentin" -Surname "Martinez" -Title "Stagiaire RH" -Department "Stagiaires" -Path "OU=Stagiaires,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\qmartine" -OfficePhone "+33158543555" -Office "C-4003"
New-ADUser -Name "Marie Vincent" -SamAccountName "mvincent" -UserPrincipalName "mvincent@aiitops.local" -GivenName "Marie" -Surname "Vincent" -Title "Stagiaire Réseau" -Department "Stagiaires" -Path "OU=Stagiaires,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\mvincent" -OfficePhone "+33153161324" -Office "C-1006"
New-ADUser -Name "Delphine Thomas" -SamAccountName "dthomas" -UserPrincipalName "dthomas@aiitops.local" -GivenName "Delphine" -Surname "Thomas" -Title "Stagiaire Développement" -Department "Stagiaires" -Path "OU=Stagiaires,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -HomeDrive "H:" -HomeDirectory "\\SRV-DC\Home\dthomas" -OfficePhone "+33177599948" -Office "C-2001"

# ── Managers ──
Set-ADUser -Identity "cbernard" -Manager (Get-ADUser -Identity "pgarcia").DistinguishedName
Set-ADUser -Identity "rmoreau" -Manager (Get-ADUser -Identity "mroux").DistinguishedName
Set-ADUser -Identity "ypetit" -Manager (Get-ADUser -Identity "mroux").DistinguishedName
Set-ADUser -Identity "cmartine" -Manager (Get-ADUser -Identity "mroux").DistinguishedName
Set-ADUser -Identity "opetit" -Manager (Get-ADUser -Identity "lrobert").DistinguishedName
Set-ADUser -Identity "xandre" -Manager (Get-ADUser -Identity "lrobert").DistinguishedName
Set-ADUser -Identity "idavid" -Manager (Get-ADUser -Identity "lrobert").DistinguishedName
Set-ADUser -Identity "jbertran" -Manager (Get-ADUser -Identity "nmorel").DistinguishedName
Set-ADUser -Identity "mdupont" -Manager (Get-ADUser -Identity "nmorel").DistinguishedName
Set-ADUser -Identity "ddurand" -Manager (Get-ADUser -Identity "nmorel").DistinguishedName
Set-ADUser -Identity "ymercier" -Manager (Get-ADUser -Identity "nmorel").DistinguishedName
Set-ADUser -Identity "adurand" -Manager (Get-ADUser -Identity "nmorel").DistinguishedName
Set-ADUser -Identity "schevali" -Manager (Get-ADUser -Identity "cbertran").DistinguishedName
Set-ADUser -Identity "iblanc" -Manager (Get-ADUser -Identity "cbertran").DistinguishedName
Set-ADUser -Identity "ileroy" -Manager (Get-ADUser -Identity "lrichard").DistinguishedName
Set-ADUser -Identity "hbonnet" -Manager (Get-ADUser -Identity "lrichard").DistinguishedName
Set-ADUser -Identity "zlefevre" -Manager (Get-ADUser -Identity "lrichard").DistinguishedName
Set-ADUser -Identity "cgirard" -Manager (Get-ADUser -Identity "arobert").DistinguishedName
Set-ADUser -Identity "nroussea" -Manager (Get-ADUser -Identity "arobert").DistinguishedName
Set-ADUser -Identity "élambert" -Manager (Get-ADUser -Identity "arobert").DistinguishedName
Set-ADUser -Identity "ifrancoi" -Manager (Get-ADUser -Identity "cgirard1").DistinguishedName
Set-ADUser -Identity "probert" -Manager (Get-ADUser -Identity "cgirard1").DistinguishedName
Set-ADUser -Identity "troussea" -Manager (Get-ADUser -Identity "cgirard1").DistinguishedName
Set-ADUser -Identity "agarnier" -Manager (Get-ADUser -Identity "cgirard1").DistinguishedName
Set-ADUser -Identity "mvincent" -Manager (Get-ADUser -Identity "qmartine").DistinguishedName
Set-ADUser -Identity "dthomas" -Manager (Get-ADUser -Identity "qmartine").DistinguishedName

# ── Comptes de service ──
New-ADUser -Name "Service MCP" -SamAccountName "SVC_MCP" -Path "OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -Description "Compte de service pour le serveur MCP"
New-ADUser -Name "Service Backup" -SamAccountName "SVC_Backup" -Path "OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -Description "Agent de sauvegarde Veeam"
New-ADUser -Name "Service SQL Server" -SamAccountName "SVC_SQL" -Path "OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local" -AccountPassword (ConvertTo-SecureString "MCPdemo2024!" -AsPlainText -Force) -Enabled $true -Description "Service SQL Server"

# ── Groupes de rôle ──
New-ADGroup -Name "G_DSI_Admins" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_DSI_Admins" -Members "mroux"
Add-ADGroupMember -Identity "G_DSI_Admins" -Members "rmoreau"
Add-ADGroupMember -Identity "G_DSI_Admins" -Members "ypetit"
Add-ADGroupMember -Identity "G_DSI_Admins" -Members "cmartine"
New-ADGroup -Name "G_DSI_Devs" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_DSI_Devs" -Members "nmorel"
Add-ADGroupMember -Identity "G_DSI_Devs" -Members "jbertran"
Add-ADGroupMember -Identity "G_DSI_Devs" -Members "mdupont"
Add-ADGroupMember -Identity "G_DSI_Devs" -Members "ddurand"
Add-ADGroupMember -Identity "G_DSI_Devs" -Members "ymercier"
Add-ADGroupMember -Identity "G_DSI_Devs" -Members "adurand"
New-ADGroup -Name "G_DSI_Support" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_DSI_Support" -Members "lrobert"
Add-ADGroupMember -Identity "G_DSI_Support" -Members "opetit"
Add-ADGroupMember -Identity "G_DSI_Support" -Members "xandre"
Add-ADGroupMember -Identity "G_DSI_Support" -Members "idavid"
New-ADGroup -Name "G_RH" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_RH" -Members "cbertran"
Add-ADGroupMember -Identity "G_RH" -Members "schevali"
Add-ADGroupMember -Identity "G_RH" -Members "iblanc"
New-ADGroup -Name "G_Compta" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_Compta" -Members "lrichard"
Add-ADGroupMember -Identity "G_Compta" -Members "ileroy"
Add-ADGroupMember -Identity "G_Compta" -Members "hbonnet"
Add-ADGroupMember -Identity "G_Compta" -Members "zlefevre"
New-ADGroup -Name "G_Commercial" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_Commercial" -Members "arobert"
Add-ADGroupMember -Identity "G_Commercial" -Members "cgirard"
Add-ADGroupMember -Identity "G_Commercial" -Members "nroussea"
Add-ADGroupMember -Identity "G_Commercial" -Members "élambert"
New-ADGroup -Name "G_Production" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_Production" -Members "cgirard1"
Add-ADGroupMember -Identity "G_Production" -Members "ifrancoi"
Add-ADGroupMember -Identity "G_Production" -Members "probert"
Add-ADGroupMember -Identity "G_Production" -Members "troussea"
Add-ADGroupMember -Identity "G_Production" -Members "agarnier"
New-ADGroup -Name "G_Direction" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
Add-ADGroupMember -Identity "G_Direction" -Members "pgarcia"
Add-ADGroupMember -Identity "G_Direction" -Members "cbernard"

# ── Groupes de ressource ──
New-ADGroup -Name "DL_Services_DSI_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
New-ADGroup -Name "DL_Services_DSI_RO" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
New-ADGroup -Name "DL_Services_RH_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
New-ADGroup -Name "DL_Services_Compta_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
New-ADGroup -Name "DL_Services_Commercial_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
New-ADGroup -Name "DL_Services_Production_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"
New-ADGroup -Name "DL_Services_Direction_RO" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"

# ── Partages + ACLs ──
New-Item -ItemType Directory -Path "E:\Shares\Services" -Force
New-Item -ItemType Directory -Path "E:\Shares\Services\DSI" -Force
New-Item -ItemType Directory -Path "E:\Shares\Services\RH" -Force
New-Item -ItemType Directory -Path "E:\Shares\Services\Comptabilité" -Force
New-Item -ItemType Directory -Path "E:\Shares\Services\Commercial" -Force
New-Item -ItemType Directory -Path "E:\Shares\Services\Production" -Force
New-Item -ItemType Directory -Path "E:\Shares\Services\Direction" -Force
New-SmbShare -Name "Services" -Path "E:\Shares\Services" -FullAccess "Utilisateurs du domaine"
$acl = Get-Acl "E:\Shares\Services\DSI"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\DL_Services_DSI_RW","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Services\DSI" $acl
$acl = Get-Acl "E:\Shares\Services\RH"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\DL_Services_RH_RW","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Services\RH" $acl
$acl = Get-Acl "E:\Shares\Services\Comptabilité"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\DL_Services_Compta_RW","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Services\Comptabilité" $acl
$acl = Get-Acl "E:\Shares\Services\Commercial"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\DL_Services_Commercial_RW","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Services\Commercial" $acl
$acl = Get-Acl "E:\Shares\Services\Production"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\DL_Services_Production_RW","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Services\Production" $acl
$acl = Get-Acl "E:\Shares\Services\Direction"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\DL_Services_Direction_RO","Read","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Services\Direction" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home" -Force
New-SmbShare -Name "Home" -Path "E:\Shares\Home" -FullAccess "Utilisateurs du domaine"
$acl = Get-Acl "E:\Shares\Home"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\Utilisateurs du domaine","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home" $acl

# ── Home folders per user ──
New-Item -ItemType Directory -Path "E:\Shares\Home\pgarcia" -Force
$acl = Get-Acl "E:\Shares\Home\pgarcia"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\pgarcia","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\pgarcia" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\cbernard" -Force
$acl = Get-Acl "E:\Shares\Home\cbernard"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\cbernard","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\cbernard" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\mroux" -Force
$acl = Get-Acl "E:\Shares\Home\mroux"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\mroux","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\mroux" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\rmoreau" -Force
$acl = Get-Acl "E:\Shares\Home\rmoreau"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\rmoreau","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\rmoreau" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\ypetit" -Force
$acl = Get-Acl "E:\Shares\Home\ypetit"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\ypetit","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\ypetit" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\cmartine" -Force
$acl = Get-Acl "E:\Shares\Home\cmartine"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\cmartine","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\cmartine" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\lrobert" -Force
$acl = Get-Acl "E:\Shares\Home\lrobert"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\lrobert","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\lrobert" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\opetit" -Force
$acl = Get-Acl "E:\Shares\Home\opetit"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\opetit","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\opetit" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\xandre" -Force
$acl = Get-Acl "E:\Shares\Home\xandre"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\xandre","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\xandre" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\idavid" -Force
$acl = Get-Acl "E:\Shares\Home\idavid"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\idavid","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\idavid" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\nmorel" -Force
$acl = Get-Acl "E:\Shares\Home\nmorel"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\nmorel","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\nmorel" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\jbertran" -Force
$acl = Get-Acl "E:\Shares\Home\jbertran"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\jbertran","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\jbertran" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\mdupont" -Force
$acl = Get-Acl "E:\Shares\Home\mdupont"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\mdupont","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\mdupont" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\ddurand" -Force
$acl = Get-Acl "E:\Shares\Home\ddurand"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\ddurand","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\ddurand" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\ymercier" -Force
$acl = Get-Acl "E:\Shares\Home\ymercier"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\ymercier","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\ymercier" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\adurand" -Force
$acl = Get-Acl "E:\Shares\Home\adurand"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\adurand","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\adurand" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\cbertran" -Force
$acl = Get-Acl "E:\Shares\Home\cbertran"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\cbertran","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\cbertran" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\schevali" -Force
$acl = Get-Acl "E:\Shares\Home\schevali"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\schevali","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\schevali" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\iblanc" -Force
$acl = Get-Acl "E:\Shares\Home\iblanc"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\iblanc","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\iblanc" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\lrichard" -Force
$acl = Get-Acl "E:\Shares\Home\lrichard"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\lrichard","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\lrichard" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\ileroy" -Force
$acl = Get-Acl "E:\Shares\Home\ileroy"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\ileroy","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\ileroy" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\hbonnet" -Force
$acl = Get-Acl "E:\Shares\Home\hbonnet"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\hbonnet","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\hbonnet" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\zlefevre" -Force
$acl = Get-Acl "E:\Shares\Home\zlefevre"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\zlefevre","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\zlefevre" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\arobert" -Force
$acl = Get-Acl "E:\Shares\Home\arobert"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\arobert","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\arobert" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\cgirard" -Force
$acl = Get-Acl "E:\Shares\Home\cgirard"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\cgirard","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\cgirard" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\nroussea" -Force
$acl = Get-Acl "E:\Shares\Home\nroussea"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\nroussea","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\nroussea" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\élambert" -Force
$acl = Get-Acl "E:\Shares\Home\élambert"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\élambert","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\élambert" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\cgirard1" -Force
$acl = Get-Acl "E:\Shares\Home\cgirard1"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\cgirard1","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\cgirard1" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\ifrancoi" -Force
$acl = Get-Acl "E:\Shares\Home\ifrancoi"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\ifrancoi","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\ifrancoi" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\probert" -Force
$acl = Get-Acl "E:\Shares\Home\probert"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\probert","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\probert" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\troussea" -Force
$acl = Get-Acl "E:\Shares\Home\troussea"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\troussea","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\troussea" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\agarnier" -Force
$acl = Get-Acl "E:\Shares\Home\agarnier"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\agarnier","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\agarnier" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\qmartine" -Force
$acl = Get-Acl "E:\Shares\Home\qmartine"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\qmartine","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\qmartine" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\mvincent" -Force
$acl = Get-Acl "E:\Shares\Home\mvincent"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\mvincent","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\mvincent" $acl
New-Item -ItemType Directory -Path "E:\Shares\Home\dthomas" -Force
$acl = Get-Acl "E:\Shares\Home\dthomas"; $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("AIITOPS\dthomas","Modify","ContainerInherit,ObjectInherit","None","Allow"); $acl.AddAccessRule($rule); Set-Acl "E:\Shares\Home\dthomas" $acl

Write-Host "AD Seed terminé. Redémarrage dans 5 secondes..."
Start-Sleep 5
Restart-Computer -Force