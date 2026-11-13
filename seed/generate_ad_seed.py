#!/usr/bin/env python3
"""Déterministe : graine fixe → AD seed pour l'épisode MCP."""

import json, random, textwrap
from pathlib import Path

SEED = 42
random.seed(SEED)

# ── Corpus de noms français ──────────────────────────────────────────
FIRST_NAMES = [
    "Antoine", "Benoît", "Charlotte", "Delphine", "Éric", "Fabienne",
    "Guillaume", "Hélène", "Isabelle", "Jean", "Karine", "Laurent",
    "Marie", "Nicolas", "Olivier", "Pauline", "Quentin", "Romane",
    "Sophie", "Thomas", "Ulysse", "Valérie", "William", "Xavier",
    "Yasmine", "Zacharie", "Amélie", "Bastien", "Céline", "Damien",
    "Élodie", "François", "Gaëlle", "Henri", "Inès", "Jérôme",
    "Laura", "Mathieu", "Nadège", "Pierre", "Stéphanie", "Thierry",
    "Camille", "Vincent", "Manon", "Lucas", "Chloé", "Maxime",
]

LAST_NAMES = [
    "Martin", "Bernard", "Dubois", "Thomas", "Robert", "Richard",
    "Petit", "Durand", "Leroy", "Moreau", "Simon", "Laurent",
    "Lefebvre", "Michel", "Garcia", "David", "Bertrand", "Roux",
    "Vincent", "Fournier", "Morel", "Girard", "Andre", "Lefevre",
    "Mercier", "Dupont", "Lambert", "Bonnet", "Francois", "Martinez",
    "Legrand", "Garnier", "Chevalier", "Blanc", "Rousseau", "Perrin",
]

DEPT_STRUCTURE = {                     # (code, parent_ou)
    "Direction":            ("DIR",  None),
    "DSI":                  ("DSI",  "Direction"),
    "DSI/Infrastructure":   ("INFRA","DSI"),
    "DSI/Support":          ("SUPP", "DSI"),
    "DSI/Développement":    ("DEV",  "DSI"),
    "RH":                   ("RH",   "Direction"),
    "Comptabilité":         ("CPTA", "Direction"),
    "Commercial":           ("COMM", "Direction"),
    "Production":           ("PROD", "Direction"),
    "Stagiaires":           ("STG",  "Direction"),
}

USERS_PER_DEPT = {
    "Direction": 2, "DSI/Infrastructure": 4, "DSI/Support": 4,
    "DSI/Développement": 6, "RH": 3, "Comptabilité": 4,
    "Commercial": 4, "Production": 5, "Stagiaires": 3,
}

TITLES = {
    "Direction":            ["Directeur Général", "Assistante de Direction"],
    "DSI/Infrastructure":   ["Admin Réseau", "Admin Système", "Tech Support", "Ingénieur Cloud"],
    "DSI/Support":          ["Support N1", "Support N2", "Support N3", "Responsable Support"],
    "DSI/Développement":    ["Développeur Backend", "Développeur Frontend", "Lead Dev", "DevOps", "Développeur Full-Stack", "Architecte Logiciel"],
    "RH":                   ["Responsable RH", "Gestionnaire RH", "Chargé de recrutement"],
    "Comptabilité":         ["Chef Comptable", "Comptable", "Assistant Comptable", "Contrôleur de Gestion"],
    "Commercial":           ["Commercial Sédentaire", "Responsable Commercial", "Business Developer", "Chargé de Clientèle"],
    "Production":           ["Chef de Projet", "Product Manager", "Designer UX", "Designer UI", "Scrum Master"],
    "Stagiaires":           ["Stagiaire Développement", "Stagiaire Réseau", "Stagiaire RH", "Stagiaire Compta"],
}

# ── Helpers ───────────────────────────────────────────────────────────
def _u(users, match): return next(u for u in users if u["username"]==match)

def group_by(users, key):
    d = {}
    for u in users:
        d.setdefault(u[key], []).append(u)
    return d

def gen_username(first, last, existing):
    base = first[0].lower() + last.lower().replace(" ","")[:7]
    name, s = base, 0
    while name in existing:
        s += 1; name = f"{base}{s}"
    existing.add(name)
    return name

# ── Generate ──────────────────────────────────────────────────────────
def generate():
    users = []
    names_seen = set()
    used_usernames = set()
    uid = 1000

    for dept, count in USERS_PER_DEPT.items():
        dept_code, _ = DEPT_STRUCTURE[dept]
        dept_leaf = dept.split("/")[-1]
        titles = TITLES[dept] * ((count // len(TITLES[dept])) + 1)
        random.shuffle(titles)

        for i in range(count):
            while True:
                first = random.choice(FIRST_NAMES)
                last  = random.choice(LAST_NAMES)
                if f"{first}|{last}" not in names_seen:
                    names_seen.add(f"{first}|{last}")
                    break

            username = gen_username(first, last, used_usernames)
            user = {
                "username":      username,
                "firstName":     first,
                "lastName":      last,
                "displayName":   f"{first} {last}",
                "title":         titles[i],
                "department":    dept,
                "ou":            f"OU={dept_leaf},OU=TN,DC=aiitops,DC=local",
                "manager":       None,
                "password":      "MCPdemo2024!",
                "uidNumber":     uid,
                "homeDrive":     "H:",
                "homeDirectory": f"\\\\SRV-DC\\Home\\{username}",
                "phone":         f"+331{random.randint(40,99):02d}{random.randint(100000,999999):06d}",
                "office":        f"{random.choice(['A','B','C'])}-{random.randint(1,4)}0{random.randint(1,9):02d}",
            }
            uid += 1
            users.append(user)

    # Managers
    for dept, dept_users in group_by(users, "department").items():
        if len(dept_users) < 2: continue
        mgr = dept_users[0]
        for u in dept_users[1:]:
            u["manager"] = mgr["username"]

    # OUs
    ous = [
        {"name": "TN",       "path": "OU=TN,DC=aiitops,DC=local", "description": "Racine TechNova"},
        {"name": "Groupes",  "path": "OU=Groupes,OU=TN,DC=aiitops,DC=local"},
        {"name": "Serveurs", "path": "OU=Serveurs,OU=TN,DC=aiitops,DC=local"},
        {"name": "Ordinateurs","path":"OU=Ordinateurs,OU=TN,DC=aiitops,DC=local"},
        {"name": "Stagiaires","path":"OU=Stagiaires,OU=TN,DC=aiitops,DC=local"},
        {"name": "Comptes_de_service","path":"OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local"},
    ]
    for dept in ["Direction","DSI","RH","Comptabilité","Commercial","Production"]:
        ous.append({"name": dept, "path": f"OU={dept},OU=TN,DC=aiitops,DC=local"})

    # Groups (AGDLP)
    role_groups = [
        {"name":"G_DSI_Admins","scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_DSI_Devs",  "scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_DSI_Support","scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_RH",        "scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_Compta",    "scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_Commercial","scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_Production","scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
        {"name":"G_Direction", "scope":"Global","ou":"OU=Groupes,OU=TN,DC=aiitops,DC=local","members":[]},
    ]
    # Assign members
    dept_to_group = {
        "DSI/Infrastructure":"G_DSI_Admins","DSI/Développement":"G_DSI_Devs",
        "DSI/Support":"G_DSI_Support","RH":"G_RH","Comptabilité":"G_Compta",
        "Commercial":"G_Commercial","Production":"G_Production","Direction":"G_Direction",
    }
    # Also map parent depts
    for u in users:
        gname = dept_to_group.get(u["department"])
        if gname:
            next(g for g in role_groups if g["name"]==gname)["members"].append(u["username"])

    resource_groups = [
        {"name":"DL_Services_DSI_RW","scope":"DomainLocal","description":"Modify sur \\Services\\DSI"},
        {"name":"DL_Services_DSI_RO","scope":"DomainLocal","description":"Read sur \\Services\\DSI (stakeholders)"},
        {"name":"DL_Services_RH_RW","scope":"DomainLocal","description":"Modify sur \\Services\\RH"},
        {"name":"DL_Services_Compta_RW","scope":"DomainLocal","description":"Modify sur \\Services\\Comptabilité"},
        {"name":"DL_Services_Commercial_RW","scope":"DomainLocal","description":"Modify sur \\Services\\Commercial"},
        {"name":"DL_Services_Production_RW","scope":"DomainLocal","description":"Modify sur \\Services\\Production"},
        {"name":"DL_Services_Direction_RO","scope":"DomainLocal","description":"Read sur \\Services\\Direction"},
    ]

    # Shares + permissions
    shares = [
        {"name":"Services","uncPath":"\\\\SRV-DC\\Services","localPath":"E:\\Shares\\Services",
         "subdirs":["DSI","RH","Comptabilité","Commercial","Production","Direction"],
         "permissions":[
             {"group":"DL_Services_DSI_RW","folder":"DSI","rights":"Modify"},
             {"group":"DL_Services_RH_RW","folder":"RH","rights":"Modify"},
             {"group":"DL_Services_Compta_RW","folder":"Comptabilité","rights":"Modify"},
             {"group":"DL_Services_Commercial_RW","folder":"Commercial","rights":"Modify"},
             {"group":"DL_Services_Production_RW","folder":"Production","rights":"Modify"},
             {"group":"DL_Services_Direction_RO","folder":"Direction","rights":"Read"},
         ]},
        {"name":"Home","uncPath":"\\\\SRV-DC\\Home","localPath":"E:\\Shares\\Home",
         "subdirs":[],"permissions":[{"group":"Utilisateurs du domaine","folder":"","rights":"Modify"}]},
    ]

    # Service accounts
    service_accounts = [
        {"username":"SVC_MCP","displayName":"Service MCP","ou":"OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local",
         "password":"MCPdemo2024!","description":"Compte de service pour le serveur MCP"},
        {"username":"SVC_Backup","displayName":"Service Backup","ou":"OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local",
         "password":"MCPdemo2024!","description":"Agent de sauvegarde Veeam"},
        {"username":"SVC_SQL","displayName":"Service SQL Server","ou":"OU=Comptes_de_service,OU=TN,DC=aiitops,DC=local",
         "password":"MCPdemo2024!","description":"Service SQL Server"},
    ]

    seed = {
        "domain": "aiitops.local",
        "netbios": "AIITOPS",
        "dc_hostname": "SRV-DC",
        "dc_ip": "192.168.1.241",
        "seed": SEED,
        "ous": ous,
        "users": users,
        "service_accounts": service_accounts,
        "role_groups": role_groups,
        "resource_groups": resource_groups,
        "shares": shares,
    }
    return seed


# ── PowerShell generator ──────────────────────────────────────────────
def to_ps1(seed):
    """Génère un script PowerShell qui crée tout l'AD."""
    pwd = seed["users"][0]["password"]
    upn_suffix = "@" + seed["domain"]

    lines = [
        f'# AD Seed pour {seed["domain"]} — généré avec SEED={seed["seed"]}',
        f'# Ce script crée la forêt, les OUs, utilisateurs, groupes et partages.',
        f'',
        f'$DomainName = "{seed["domain"]}"',
        f'$NetBIOS   = "{seed["netbios"]}"',
        f'$SafeModePwd = ConvertTo-SecureString "{pwd}" -AsPlainText -Force',
        f'',
        f'# ── Installer AD DS + créer la forêt ──',
        f'Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools',
        f'Import-Module ADDSDeployment',
        f'Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetBIOS '
          f'-SafeModeAdministratorPassword $SafeModePwd -InstallDNS -Force',
        f'',
        f'# ── OUs ──',
    ]
    for ou in seed["ous"]:
        name = ou["name"]; path = ou["path"]
        parent = ",".join(path.split(",")[1:])
        lines.append(f'New-ADOrganizationalUnit -Name "{name}" -Path "{parent}" -ProtectedFromAccidentalDeletion $false')

    lines += ['', '# ── Utilisateurs ──']
    # Group users by OU for cleaner script
    by_ou = {}
    for u in seed["users"]:
        by_ou.setdefault(u["ou"], []).append(u)
    for ou_path, us in by_ou.items():
        for u in us:
            upn = u["username"] + upn_suffix
            lines.append(
                f'New-ADUser -Name "{u["displayName"]}" -SamAccountName "{u["username"]}" '
                f'-UserPrincipalName "{upn}" -GivenName "{u["firstName"]}" '
                f'-Surname "{u["lastName"]}" -Title "{u["title"]}" '
                f'-Department "{u["department"]}" -Path "{u["ou"]}" '
                f'-AccountPassword (ConvertTo-SecureString "{u["password"]}" -AsPlainText -Force) '
                f'-Enabled $true -HomeDrive "{u["homeDrive"]}" -HomeDirectory "{u["homeDirectory"]}" '
                f'-OfficePhone "{u["phone"]}" -Office "{u["office"]}"'
            )

    lines += ['', '# ── Managers ──']
    for u in seed["users"]:
        if u["manager"]:
            lines.append(
                f'Set-ADUser -Identity "{u["username"]}" '
                f'-Manager (Get-ADUser -Identity "{u["manager"]}").DistinguishedName'
            )

    lines += ['', '# ── Comptes de service ──']
    for sa in seed["service_accounts"]:
        lines.append(
            f'New-ADUser -Name "{sa["displayName"]}" -SamAccountName "{sa["username"]}" '
            f'-Path "{sa["ou"]}" -AccountPassword (ConvertTo-SecureString "{sa["password"]}" -AsPlainText -Force) '
            f'-Enabled $true -Description "{sa["description"]}"'
        )

    lines += ['', '# ── Groupes de rôle ──']
    for g in seed["role_groups"]:
        lines.append(
            f'New-ADGroup -Name "{g["name"]}" -GroupScope {g["scope"]} '
            f'-GroupCategory Security -Path "{g["ou"]}"'
        )
        for member in g["members"]:
            lines.append(f'Add-ADGroupMember -Identity "{g["name"]}" -Members "{member}"')

    lines += ['', '# ── Groupes de ressource ──']
    for g in seed["resource_groups"]:
        lines.append(
            f'New-ADGroup -Name "{g["name"]}" -GroupScope {g["scope"]} '
            f'-GroupCategory Security -Path "OU=Groupes,OU=TN,DC=aiitops,DC=local"'
        )

    lines += ['', '# ── Partages + ACLs ──']
    for s in seed["shares"]:
        path = s["localPath"]
        share = s["name"]
        unc = s["uncPath"]
        lines += [
            f'New-Item -ItemType Directory -Path "{path}" -Force',
        ]
        for sub in s["subdirs"]:
            lines.append(f'New-Item -ItemType Directory -Path "{path}\\{sub}" -Force')
        lines += [
            f'New-SmbShare -Name "{share}" -Path "{path}" -FullAccess "Utilisateurs du domaine"',
        ]
        for perm in s["permissions"]:
            folder = f'{path}\\{perm["folder"]}' if perm["folder"] else path
            lines.append(
                f'$acl = Get-Acl "{folder}"; '
                f'$rule = New-Object System.Security.AccessControl.FileSystemAccessRule '
                f'("AIITOPS\\{perm["group"]}","{perm["rights"]}",'
                f'"ContainerInherit,ObjectInherit","None","Allow"); '
                f'$acl.AddAccessRule($rule); Set-Acl "{folder}" $acl'
            )

    lines += ['', '# ── Home folders per user ──']
    for u in seed["users"]:
        home = f'E:\\Shares\\Home\\{u["username"]}'
        lines += [
            f'New-Item -ItemType Directory -Path "{home}" -Force',
            f'$acl = Get-Acl "{home}"; '
            f'$rule = New-Object System.Security.AccessControl.FileSystemAccessRule '
            f'("AIITOPS\\{u["username"]}","Modify","ContainerInherit,ObjectInherit","None","Allow"); '
            f'$acl.AddAccessRule($rule); Set-Acl "{home}" $acl',
        ]

    lines += ['', 'Write-Host "AD Seed terminé. Redémarrage dans 5 secondes..."', 'Start-Sleep 5', 'Restart-Computer -Force']
    return "\r\n".join(lines)  # CRLF for Windows


# ── Main ──────────────────────────────────────────────────────────────
if __name__ == "__main__":
    HERE = Path(__file__).resolve().parent
    seed = generate()

    json_path = HERE / "ad_seed.json"
    json_path.write_text(json.dumps(seed, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"✓ {json_path}  ({len(seed['users'])} utilisateurs, {len(seed['ous'])} OUs)")

    ps1_path = HERE / "provision_ad.ps1"
    ps1_path.write_text(to_ps1(seed), encoding="utf-8")
    print(f"✓ {ps1_path}  (script PowerShell standalone)")