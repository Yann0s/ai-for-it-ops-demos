# AD Seed pour aiitops.local — généré depuis ad_seed.json (SEED=42)
# À exécuter sur un contrôleur de domaine déjà promu (voir promote_dc.ps1).
# Crée les OU, les comptes, les groupes, les partages et les dossiers personnels.
# Généré par seed/build_provision.py — ne pas éditer à la main.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$root = 'DC=aiitops,DC=local'
$pwdUser = ConvertTo-SecureString 'MCPdemo2024!' -AsPlainText -Force
$t0 = Get-Date
Write-Host ''
Write-Host '=== provisionnement de aiitops.local ===' -ForegroundColor Cyan

# --- OU ---
$nOu = 0
foreach ($dn in @(
  'OU=TN,DC=aiitops,DC=local',
  'OU=Commercial,OU=TN,DC=aiitops,DC=local',
  'OU=Comptabilité,OU=TN,DC=aiitops,DC=local',
  'OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local',
  'OU=DSI,OU=TN,DC=aiitops,DC=local',
  'OU=Direction,OU=TN,DC=aiitops,DC=local',
  'OU=Développement,OU=TN,DC=aiitops,DC=local',
  'OU=Groupes,OU=TN,DC=aiitops,DC=local',
  'OU=Infrastructure,OU=TN,DC=aiitops,DC=local',
  'OU=Ordinateurs,OU=TN,DC=aiitops,DC=local',
  'OU=Production,OU=TN,DC=aiitops,DC=local',
  'OU=RH,OU=TN,DC=aiitops,DC=local',
  'OU=Serveurs,OU=TN,DC=aiitops,DC=local',
  'OU=Stagiaires,OU=TN,DC=aiitops,DC=local',
  'OU=Support,OU=TN,DC=aiitops,DC=local'
)) {
  $exists = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'" -ErrorAction SilentlyContinue
  if (-not $exists) {
    $name = ($dn -split ',')[0] -replace '^OU=', ''
    $parent = ($dn -split ',', 2)[1]
    New-ADOrganizationalUnit -Name $name -Path $parent -ProtectedFromAccidentalDeletion $false
    $nOu++
  }
}
Write-Host ('[OU]      {0} unites d organisation' -f $nOu) -ForegroundColor Green

# --- Utilisateurs nominatifs, OU par OU ---
$nUser = 0
# OU=Commercial,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Antoine Robert' -SamAccountName 'arobert' -UserPrincipalName 'arobert@aiitops.local' -GivenName 'Antoine' -Surname 'Robert' -DisplayName 'Antoine Robert' -Title 'Chargé de Clientèle' -Department 'Commercial' -Path 'OU=Commercial,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\arobert' -OfficePhone '+33185761759' -Office 'A-2002'
$nUser++
New-ADUser -Name 'Charlotte Girard' -SamAccountName 'cgirard' -UserPrincipalName 'cgirard@aiitops.local' -GivenName 'Charlotte' -Surname 'Girard' -DisplayName 'Charlotte Girard' -Title 'Commercial Sédentaire' -Department 'Commercial' -Path 'OU=Commercial,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\cgirard' -OfficePhone '+33144639131' -Office 'A-3008'
$nUser++
New-ADUser -Name 'Nicolas Rousseau' -SamAccountName 'nroussea' -UserPrincipalName 'nroussea@aiitops.local' -GivenName 'Nicolas' -Surname 'Rousseau' -DisplayName 'Nicolas Rousseau' -Title 'Responsable Commercial' -Department 'Commercial' -Path 'OU=Commercial,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\nroussea' -OfficePhone '+33148858490' -Office 'C-4004'
$nUser++
New-ADUser -Name 'Élodie Lambert' -SamAccountName 'elambert' -UserPrincipalName 'elambert@aiitops.local' -GivenName 'Élodie' -Surname 'Lambert' -DisplayName 'Élodie Lambert' -Title 'Responsable Commercial' -Department 'Commercial' -Path 'OU=Commercial,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\élambert' -OfficePhone '+33152198907' -Office 'A-4006'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Commercial', 4)
# OU=Comptabilité,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Laura Richard' -SamAccountName 'lrichard' -UserPrincipalName 'lrichard@aiitops.local' -GivenName 'Laura' -Surname 'Richard' -DisplayName 'Laura Richard' -Title 'Contrôleur de Gestion' -Department 'Comptabilité' -Path 'OU=Comptabilité,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\lrichard' -OfficePhone '+33145867460' -Office 'B-1009'
$nUser++
New-ADUser -Name 'Isabelle Leroy' -SamAccountName 'ileroy' -UserPrincipalName 'ileroy@aiitops.local' -GivenName 'Isabelle' -Surname 'Leroy' -DisplayName 'Isabelle Leroy' -Title 'Chef Comptable' -Department 'Comptabilité' -Path 'OU=Comptabilité,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\ileroy' -OfficePhone '+33182598369' -Office 'C-2005'
$nUser++
New-ADUser -Name 'Henri Bonnet' -SamAccountName 'hbonnet' -UserPrincipalName 'hbonnet@aiitops.local' -GivenName 'Henri' -Surname 'Bonnet' -DisplayName 'Henri Bonnet' -Title 'Assistant Comptable' -Department 'Comptabilité' -Path 'OU=Comptabilité,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\hbonnet' -OfficePhone '+33153665492' -Office 'C-2005'
$nUser++
New-ADUser -Name 'Zacharie Lefevre' -SamAccountName 'zlefevre' -UserPrincipalName 'zlefevre@aiitops.local' -GivenName 'Zacharie' -Surname 'Lefevre' -DisplayName 'Zacharie Lefevre' -Title 'Comptable' -Department 'Comptabilité' -Path 'OU=Comptabilité,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\zlefevre' -OfficePhone '+33168642717' -Office 'B-1004'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Comptabilité', 4)
# OU=Direction,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Pauline Garcia' -SamAccountName 'pgarcia' -UserPrincipalName 'pgarcia@aiitops.local' -GivenName 'Pauline' -Surname 'Garcia' -DisplayName 'Pauline Garcia' -Title 'Directeur Général' -Department 'Direction' -Path 'OU=Direction,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\pgarcia' -OfficePhone '+33148872246' -Office 'A-1007'
$nUser++
New-ADUser -Name 'Charlotte Bernard' -SamAccountName 'cbernard' -UserPrincipalName 'cbernard@aiitops.local' -GivenName 'Charlotte' -Surname 'Bernard' -DisplayName 'Charlotte Bernard' -Title 'Assistante de Direction' -Department 'Direction' -Path 'OU=Direction,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\cbernard' -OfficePhone '+33145329258' -Office 'A-1009'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Direction', 2)
# OU=Développement,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Nicolas Morel' -SamAccountName 'nmorel' -UserPrincipalName 'nmorel@aiitops.local' -GivenName 'Nicolas' -Surname 'Morel' -DisplayName 'Nicolas Morel' -Title 'Développeur Full-Stack' -Department 'DSI/Développement' -Path 'OU=Développement,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\nmorel' -OfficePhone '+33153787277' -Office 'B-4008'
$nUser++
New-ADUser -Name 'Jean Bertrand' -SamAccountName 'jbertran' -UserPrincipalName 'jbertran@aiitops.local' -GivenName 'Jean' -Surname 'Bertrand' -DisplayName 'Jean Bertrand' -Title 'DevOps' -Department 'DSI/Développement' -Path 'OU=Développement,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\jbertran' -OfficePhone '+33148358607' -Office 'C-3007'
$nUser++
New-ADUser -Name 'Mathieu Dupont' -SamAccountName 'mdupont' -UserPrincipalName 'mdupont@aiitops.local' -GivenName 'Mathieu' -Surname 'Dupont' -DisplayName 'Mathieu Dupont' -Title 'Développeur Frontend' -Department 'DSI/Développement' -Path 'OU=Développement,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\mdupont' -OfficePhone '+33163329974' -Office 'A-4002'
$nUser++
New-ADUser -Name 'Delphine Durand' -SamAccountName 'ddurand' -UserPrincipalName 'ddurand@aiitops.local' -GivenName 'Delphine' -Surname 'Durand' -DisplayName 'Delphine Durand' -Title 'Développeur Frontend' -Department 'DSI/Développement' -Path 'OU=Développement,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\ddurand' -OfficePhone '+33149757924' -Office 'A-4002'
$nUser++
New-ADUser -Name 'Yasmine Mercier' -SamAccountName 'ymercier' -UserPrincipalName 'ymercier@aiitops.local' -GivenName 'Yasmine' -Surname 'Mercier' -DisplayName 'Yasmine Mercier' -Title 'Lead Dev' -Department 'DSI/Développement' -Path 'OU=Développement,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\ymercier' -OfficePhone '+33178590785' -Office 'C-3009'
$nUser++
New-ADUser -Name 'Antoine Durand' -SamAccountName 'adurand' -UserPrincipalName 'adurand@aiitops.local' -GivenName 'Antoine' -Surname 'Durand' -DisplayName 'Antoine Durand' -Title 'Lead Dev' -Department 'DSI/Développement' -Path 'OU=Développement,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\adurand' -OfficePhone '+33183663054' -Office 'B-3002'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Développement', 6)
# OU=Infrastructure,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Mathieu Roux' -SamAccountName 'mroux' -UserPrincipalName 'mroux@aiitops.local' -GivenName 'Mathieu' -Surname 'Roux' -DisplayName 'Mathieu Roux' -Title 'Tech Support' -Department 'DSI/Infrastructure' -Path 'OU=Infrastructure,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\mroux' -OfficePhone '+33191106814' -Office 'A-4006'
$nUser++
New-ADUser -Name 'Romane Moreau' -SamAccountName 'rmoreau' -UserPrincipalName 'rmoreau@aiitops.local' -GivenName 'Romane' -Surname 'Moreau' -DisplayName 'Romane Moreau' -Title 'Admin Système' -Department 'DSI/Infrastructure' -Path 'OU=Infrastructure,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\rmoreau' -OfficePhone '+33153900581' -Office 'B-1002'
$nUser++
New-ADUser -Name 'Yasmine Petit' -SamAccountName 'ypetit' -UserPrincipalName 'ypetit@aiitops.local' -GivenName 'Yasmine' -Surname 'Petit' -DisplayName 'Yasmine Petit' -Title 'Admin Réseau' -Department 'DSI/Infrastructure' -Path 'OU=Infrastructure,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\ypetit' -OfficePhone '+33162988662' -Office 'B-3001'
$nUser++
New-ADUser -Name 'Chloé Martinez' -SamAccountName 'cmartine' -UserPrincipalName 'cmartine@aiitops.local' -GivenName 'Chloé' -Surname 'Martinez' -DisplayName 'Chloé Martinez' -Title 'Ingénieur Cloud' -Department 'DSI/Infrastructure' -Path 'OU=Infrastructure,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\cmartine' -OfficePhone '+33174230889' -Office 'B-1009'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Infrastructure', 4)
# OU=Production,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Chloé Girard' -SamAccountName 'cgirard1' -UserPrincipalName 'cgirard1@aiitops.local' -GivenName 'Chloé' -Surname 'Girard' -DisplayName 'Chloé Girard' -Title 'Designer UX' -Department 'Production' -Path 'OU=Production,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\cgirard1' -OfficePhone '+33191214576' -Office 'A-2004'
$nUser++
New-ADUser -Name 'Inès Francois' -SamAccountName 'ifrancoi' -UserPrincipalName 'ifrancoi@aiitops.local' -GivenName 'Inès' -Surname 'Francois' -DisplayName 'Inès Francois' -Title 'Product Manager' -Department 'Production' -Path 'OU=Production,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\ifrancoi' -OfficePhone '+33148542374' -Office 'A-3008'
$nUser++
New-ADUser -Name 'Pauline Robert' -SamAccountName 'probert' -UserPrincipalName 'probert@aiitops.local' -GivenName 'Pauline' -Surname 'Robert' -DisplayName 'Pauline Robert' -Title 'Designer UI' -Department 'Production' -Path 'OU=Production,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\probert' -OfficePhone '+33168947272' -Office 'C-1001'
$nUser++
New-ADUser -Name 'Thierry Rousseau' -SamAccountName 'troussea' -UserPrincipalName 'troussea@aiitops.local' -GivenName 'Thierry' -Surname 'Rousseau' -DisplayName 'Thierry Rousseau' -Title 'Scrum Master' -Department 'Production' -Path 'OU=Production,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\troussea' -OfficePhone '+33193115474' -Office 'A-2003'
$nUser++
New-ADUser -Name 'Amélie Garnier' -SamAccountName 'agarnier' -UserPrincipalName 'agarnier@aiitops.local' -GivenName 'Amélie' -Surname 'Garnier' -DisplayName 'Amélie Garnier' -Title 'Chef de Projet' -Department 'Production' -Path 'OU=Production,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\agarnier' -OfficePhone '+33170324130' -Office 'B-1003'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Production', 5)
# OU=RH,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Chloé Bertrand' -SamAccountName 'cbertran' -UserPrincipalName 'cbertran@aiitops.local' -GivenName 'Chloé' -Surname 'Bertrand' -DisplayName 'Chloé Bertrand' -Title 'Chargé de recrutement' -Department 'RH' -Path 'OU=RH,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\cbertran' -OfficePhone '+33172898975' -Office 'A-1005'
$nUser++
New-ADUser -Name 'Stéphanie Chevalier' -SamAccountName 'schevali' -UserPrincipalName 'schevali@aiitops.local' -GivenName 'Stéphanie' -Surname 'Chevalier' -DisplayName 'Stéphanie Chevalier' -Title 'Responsable RH' -Department 'RH' -Path 'OU=RH,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\schevali' -OfficePhone '+33178308573' -Office 'A-3003'
$nUser++
New-ADUser -Name 'Inès Blanc' -SamAccountName 'iblanc' -UserPrincipalName 'iblanc@aiitops.local' -GivenName 'Inès' -Surname 'Blanc' -DisplayName 'Inès Blanc' -Title 'Gestionnaire RH' -Department 'RH' -Path 'OU=RH,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\iblanc' -OfficePhone '+33198100599' -Office 'C-3008'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'RH', 3)
# OU=Stagiaires,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Quentin Martinez' -SamAccountName 'qmartine' -UserPrincipalName 'qmartine@aiitops.local' -GivenName 'Quentin' -Surname 'Martinez' -DisplayName 'Quentin Martinez' -Title 'Stagiaire RH' -Department 'Stagiaires' -Path 'OU=Stagiaires,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\qmartine' -OfficePhone '+33158543555' -Office 'C-4003'
$nUser++
New-ADUser -Name 'Marie Vincent' -SamAccountName 'mvincent' -UserPrincipalName 'mvincent@aiitops.local' -GivenName 'Marie' -Surname 'Vincent' -DisplayName 'Marie Vincent' -Title 'Stagiaire Réseau' -Department 'Stagiaires' -Path 'OU=Stagiaires,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\mvincent' -OfficePhone '+33153161324' -Office 'C-1006'
$nUser++
New-ADUser -Name 'Delphine Thomas' -SamAccountName 'dthomas' -UserPrincipalName 'dthomas@aiitops.local' -GivenName 'Delphine' -Surname 'Thomas' -DisplayName 'Delphine Thomas' -Title 'Stagiaire Développement' -Department 'Stagiaires' -Path 'OU=Stagiaires,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\dthomas' -OfficePhone '+33177599948' -Office 'C-2001'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Stagiaires', 3)
# OU=Support,OU=TN,DC=aiitops,DC=local
New-ADUser -Name 'Lucas Robert' -SamAccountName 'lrobert' -UserPrincipalName 'lrobert@aiitops.local' -GivenName 'Lucas' -Surname 'Robert' -DisplayName 'Lucas Robert' -Title 'Support N2' -Department 'DSI/Support' -Path 'OU=Support,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\lrobert' -OfficePhone '+33142793384' -Office 'A-3002'
$nUser++
New-ADUser -Name 'Olivier Petit' -SamAccountName 'opetit' -UserPrincipalName 'opetit@aiitops.local' -GivenName 'Olivier' -Surname 'Petit' -DisplayName 'Olivier Petit' -Title 'Support N1' -Department 'DSI/Support' -Path 'OU=Support,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\opetit' -OfficePhone '+33164391476' -Office 'B-3003'
$nUser++
New-ADUser -Name 'Xavier Andre' -SamAccountName 'xandre' -UserPrincipalName 'xandre@aiitops.local' -GivenName 'Xavier' -Surname 'Andre' -DisplayName 'Xavier Andre' -Title 'Responsable Support' -Department 'DSI/Support' -Path 'OU=Support,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\xandre' -OfficePhone '+33153802729' -Office 'B-1003'
$nUser++
New-ADUser -Name 'Inès David' -SamAccountName 'idavid' -UserPrincipalName 'idavid@aiitops.local' -GivenName 'Inès' -Surname 'David' -DisplayName 'Inès David' -Title 'Support N3' -Department 'DSI/Support' -Path 'OU=Support,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false -HomeDrive 'H:' -HomeDirectory '\\SRV-DC\Home\idavid' -OfficePhone '+33150584714' -Office 'B-3009'
$nUser++
Write-Host ('  {0,-20} {1,2} comptes' -f 'Support', 4)
Write-Host ('[USER]    {0} comptes nominatifs' -f $nUser) -ForegroundColor Green

# --- Rattachements hierarchiques ---
Set-ADUser -Identity 'cbernard' -Manager (Get-ADUser -Identity 'pgarcia').DistinguishedName
Set-ADUser -Identity 'rmoreau' -Manager (Get-ADUser -Identity 'mroux').DistinguishedName
Set-ADUser -Identity 'ypetit' -Manager (Get-ADUser -Identity 'mroux').DistinguishedName
Set-ADUser -Identity 'cmartine' -Manager (Get-ADUser -Identity 'mroux').DistinguishedName
Set-ADUser -Identity 'opetit' -Manager (Get-ADUser -Identity 'lrobert').DistinguishedName
Set-ADUser -Identity 'xandre' -Manager (Get-ADUser -Identity 'lrobert').DistinguishedName
Set-ADUser -Identity 'idavid' -Manager (Get-ADUser -Identity 'lrobert').DistinguishedName
Set-ADUser -Identity 'jbertran' -Manager (Get-ADUser -Identity 'nmorel').DistinguishedName
Set-ADUser -Identity 'mdupont' -Manager (Get-ADUser -Identity 'nmorel').DistinguishedName
Set-ADUser -Identity 'ddurand' -Manager (Get-ADUser -Identity 'nmorel').DistinguishedName
Set-ADUser -Identity 'ymercier' -Manager (Get-ADUser -Identity 'nmorel').DistinguishedName
Set-ADUser -Identity 'adurand' -Manager (Get-ADUser -Identity 'nmorel').DistinguishedName
Set-ADUser -Identity 'schevali' -Manager (Get-ADUser -Identity 'cbertran').DistinguishedName
Set-ADUser -Identity 'iblanc' -Manager (Get-ADUser -Identity 'cbertran').DistinguishedName
Set-ADUser -Identity 'ileroy' -Manager (Get-ADUser -Identity 'lrichard').DistinguishedName
Set-ADUser -Identity 'hbonnet' -Manager (Get-ADUser -Identity 'lrichard').DistinguishedName
Set-ADUser -Identity 'zlefevre' -Manager (Get-ADUser -Identity 'lrichard').DistinguishedName
Set-ADUser -Identity 'cgirard' -Manager (Get-ADUser -Identity 'arobert').DistinguishedName
Set-ADUser -Identity 'nroussea' -Manager (Get-ADUser -Identity 'arobert').DistinguishedName
Set-ADUser -Identity 'elambert' -Manager (Get-ADUser -Identity 'arobert').DistinguishedName
Set-ADUser -Identity 'ifrancoi' -Manager (Get-ADUser -Identity 'cgirard1').DistinguishedName
Set-ADUser -Identity 'probert' -Manager (Get-ADUser -Identity 'cgirard1').DistinguishedName
Set-ADUser -Identity 'troussea' -Manager (Get-ADUser -Identity 'cgirard1').DistinguishedName
Set-ADUser -Identity 'agarnier' -Manager (Get-ADUser -Identity 'cgirard1').DistinguishedName
Set-ADUser -Identity 'mvincent' -Manager (Get-ADUser -Identity 'qmartine').DistinguishedName
Set-ADUser -Identity 'dthomas' -Manager (Get-ADUser -Identity 'qmartine').DistinguishedName
Write-Host ('[HIER]    {0} rattachements manager' -f 26) -ForegroundColor Green

# --- Comptes de service ---
New-ADUser -Name 'Service MCP' -SamAccountName 'SVC_MCP' -Path 'OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -Description 'Compte de service pour le serveur MCP' -PasswordNeverExpires $true
New-ADUser -Name 'Service Backup' -SamAccountName 'SVC_Backup' -Path 'OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -Description 'Agent de sauvegarde Veeam' -PasswordNeverExpires $true
New-ADUser -Name 'Service SQL Server' -SamAccountName 'SVC_SQL' -Path 'OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local' -AccountPassword $pwdUser -Enabled $true -Description 'Service SQL Server' -PasswordNeverExpires $true
Write-Host ('[SVC]     {0} comptes de service' -f 3) -ForegroundColor Green

# --- Groupes ---
New-ADGroup -Name 'G_DSI_Admins' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_DSI_Admins' -Members 'mroux'
Add-ADGroupMember -Identity 'G_DSI_Admins' -Members 'rmoreau'
Add-ADGroupMember -Identity 'G_DSI_Admins' -Members 'ypetit'
Add-ADGroupMember -Identity 'G_DSI_Admins' -Members 'cmartine'
New-ADGroup -Name 'G_DSI_Devs' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_DSI_Devs' -Members 'nmorel'
Add-ADGroupMember -Identity 'G_DSI_Devs' -Members 'jbertran'
Add-ADGroupMember -Identity 'G_DSI_Devs' -Members 'mdupont'
Add-ADGroupMember -Identity 'G_DSI_Devs' -Members 'ddurand'
Add-ADGroupMember -Identity 'G_DSI_Devs' -Members 'ymercier'
Add-ADGroupMember -Identity 'G_DSI_Devs' -Members 'adurand'
New-ADGroup -Name 'G_DSI_Support' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_DSI_Support' -Members 'lrobert'
Add-ADGroupMember -Identity 'G_DSI_Support' -Members 'opetit'
Add-ADGroupMember -Identity 'G_DSI_Support' -Members 'xandre'
Add-ADGroupMember -Identity 'G_DSI_Support' -Members 'idavid'
New-ADGroup -Name 'G_RH' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_RH' -Members 'cbertran'
Add-ADGroupMember -Identity 'G_RH' -Members 'schevali'
Add-ADGroupMember -Identity 'G_RH' -Members 'iblanc'
New-ADGroup -Name 'G_Compta' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_Compta' -Members 'lrichard'
Add-ADGroupMember -Identity 'G_Compta' -Members 'ileroy'
Add-ADGroupMember -Identity 'G_Compta' -Members 'hbonnet'
Add-ADGroupMember -Identity 'G_Compta' -Members 'zlefevre'
New-ADGroup -Name 'G_Commercial' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_Commercial' -Members 'arobert'
Add-ADGroupMember -Identity 'G_Commercial' -Members 'cgirard'
Add-ADGroupMember -Identity 'G_Commercial' -Members 'nroussea'
Add-ADGroupMember -Identity 'G_Commercial' -Members 'elambert'
New-ADGroup -Name 'G_Production' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_Production' -Members 'cgirard1'
Add-ADGroupMember -Identity 'G_Production' -Members 'ifrancoi'
Add-ADGroupMember -Identity 'G_Production' -Members 'probert'
Add-ADGroupMember -Identity 'G_Production' -Members 'troussea'
Add-ADGroupMember -Identity 'G_Production' -Members 'agarnier'
New-ADGroup -Name 'G_Direction' -GroupScope Global -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local'
Add-ADGroupMember -Identity 'G_Direction' -Members 'pgarcia'
Add-ADGroupMember -Identity 'G_Direction' -Members 'cbernard'
New-ADGroup -Name 'DL_Services_DSI_RW' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Modify sur \Services\DSI'
New-ADGroup -Name 'DL_Services_DSI_RO' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Read sur \Services\DSI (stakeholders)'
New-ADGroup -Name 'DL_Services_RH_RW' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Modify sur \Services\RH'
New-ADGroup -Name 'DL_Services_Compta_RW' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Modify sur \Services\Comptabilité'
New-ADGroup -Name 'DL_Services_Commercial_RW' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Modify sur \Services\Commercial'
New-ADGroup -Name 'DL_Services_Production_RW' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Modify sur \Services\Production'
New-ADGroup -Name 'DL_Services_Direction_RO' -GroupScope DomainLocal -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' -Description 'Read sur \Services\Direction'
Write-Host ('[GROUP]   {0} groupes, {1} appartenances' -f 15, 32) -ForegroundColor Green

# --- Partages ---
$svc = Get-ADGroup -Filter "Name -eq 'G_DSI_Admins'"
$p = 'C:\Shares\Services'
if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
if (-not (Test-Path (Join-Path $p 'DSI'))) { New-Item -ItemType Directory -Path (Join-Path $p 'DSI') -Force | Out-Null }
if (-not (Test-Path (Join-Path $p 'RH'))) { New-Item -ItemType Directory -Path (Join-Path $p 'RH') -Force | Out-Null }
if (-not (Test-Path (Join-Path $p 'Comptabilité'))) { New-Item -ItemType Directory -Path (Join-Path $p 'Comptabilité') -Force | Out-Null }
if (-not (Test-Path (Join-Path $p 'Commercial'))) { New-Item -ItemType Directory -Path (Join-Path $p 'Commercial') -Force | Out-Null }
if (-not (Test-Path (Join-Path $p 'Production'))) { New-Item -ItemType Directory -Path (Join-Path $p 'Production') -Force | Out-Null }
if (-not (Test-Path (Join-Path $p 'Direction'))) { New-Item -ItemType Directory -Path (Join-Path $p 'Direction') -Force | Out-Null }
if (-not (Get-SmbShare -Name 'Services' -ErrorAction SilentlyContinue)) { New-SmbShare -Name 'Services' -Path $p -FullAccess 'Utilisateurs du domaine' | Out-Null }
$d = Join-Path $p 'DSI'
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\DL_Services_DSI_RW', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$d = Join-Path $p 'RH'
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\DL_Services_RH_RW', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$d = Join-Path $p 'Comptabilité'
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\DL_Services_Compta_RW', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$d = Join-Path $p 'Commercial'
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\DL_Services_Commercial_RW', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$d = Join-Path $p 'Production'
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\DL_Services_Production_RW', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$d = Join-Path $p 'Direction'
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\DL_Services_Direction_RO', 'Read', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$p = 'C:\Shares\Home'
if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
if (-not (Get-SmbShare -Name 'Home' -ErrorAction SilentlyContinue)) { New-SmbShare -Name 'Home' -Path $p -FullAccess 'Utilisateurs du domaine' | Out-Null }
$d = Join-Path $p ''
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\Utilisateurs du domaine', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl

# --- Dossiers personnels ---
$h = 'C:\Shares\Home'
$nHome = 0
$d = Join-Path $h 'pgarcia'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\pgarcia', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'cbernard'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\cbernard', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'mroux'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\mroux', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'rmoreau'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\rmoreau', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'ypetit'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\ypetit', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'cmartine'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\cmartine', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'lrobert'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\lrobert', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'opetit'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\opetit', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'xandre'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\xandre', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'idavid'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\idavid', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'nmorel'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\nmorel', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'jbertran'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\jbertran', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'mdupont'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\mdupont', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'ddurand'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\ddurand', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'ymercier'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\ymercier', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'adurand'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\adurand', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'cbertran'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\cbertran', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'schevali'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\schevali', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'iblanc'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\iblanc', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'lrichard'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\lrichard', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'ileroy'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\ileroy', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'hbonnet'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\hbonnet', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'zlefevre'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\zlefevre', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'arobert'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\arobert', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'cgirard'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\cgirard', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'nroussea'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\nroussea', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'elambert'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\elambert', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'cgirard1'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\cgirard1', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'ifrancoi'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\ifrancoi', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'probert'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\probert', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'troussea'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\troussea', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'agarnier'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\agarnier', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'qmartine'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\qmartine', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'mvincent'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\mvincent', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
$d = Join-Path $h 'dthomas'
if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule('AIITOPS\dthomas', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl
$nHome++
Write-Host ('[HOME]    {0} dossiers personnels' -f $nHome) -ForegroundColor Green

$dt = (Get-Date) - $t0
Write-Host ''
Write-Host ('=== termine en {0:N1} s ===' -f $dt.TotalSeconds) -ForegroundColor Cyan
'{0,-14} {1}' -f 'utilisateurs', (Get-ADUser -Filter * | Measure-Object).Count
'{0,-14} {1}' -f 'groupes',      (Get-ADGroup -Filter * | Measure-Object).Count
'{0,-14} {1}' -f 'OU',           (Get-ADOrganizationalUnit -Filter * | Measure-Object).Count
'{0,-14} {1}' -f 'partages',     (Get-SmbShare | Where-Object { $_.Name -notlike '*$' } | Measure-Object).Count
