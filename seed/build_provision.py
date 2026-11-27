#!/usr/bin/env python3
"""Génère un script PowerShell de provisionnement à partir de seed/ad_seed.json.

Le script produit est destiné à être joué sur SRV-DC (déjà promu DC) : il ne
recrée pas la forêt. Il crée les OU, les comptes, les groupes et les partages,
avec une sortie compacte pensée pour être filmée.

Deux écarts assumés par rapport au seed d'origine :
  - les OU référencées par les utilisateurs mais absentes de la liste `ous`
    (Infrastructure, Support, Développement) sont créées : sans elles, 14
    comptes ne peuvent pas être placés ;
  - les partages vont dans C:\\Shares (la VM n'a pas de lecteur E:).

Usage : python build_provision.py > provision_scene.ps1
"""
import argparse
import json
import os

SEED = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ad_seed.json")
SHARE_ROOT = "C:\\Shares"
PAUSES = False


def sam(name):
    """SamAccountName sur : les accents sont interdits par AD."""
    import unicodedata
    base = unicodedata.normalize("NFKD", name).encode("ascii", "ignore").decode("ascii")
    return base.lower().replace(" ", ".")


def ps_str(s):
    return "'" + str(s).replace("'", "''") + "'"


def main():
    ap = argparse.ArgumentParser(
        description="Genere le script de provisionnement depuis ad_seed.json.")
    ap.add_argument("--pauses", action="store_true",
                    help="ajoute des pauses pour la capture video")
    ap.add_argument("--out", metavar="FICHIER",
                    help="ecrit le script (BOM UTF-8 + CRLF) au lieu de stdout")
    args = ap.parse_args()
    global PAUSES
    PAUSES = args.pauses

    d = json.load(open(SEED, encoding="utf-8"))
    users = d["users"]
    svc = d["service_accounts"]
    role_groups = d["role_groups"]
    res_groups = d["resource_groups"]

    # Toutes les OU à créer : la liste déclarée + celles citées par les objets.
    ous = {o["path"] for o in d["ous"]}
    for u in users + svc:
        ous.add(u["ou"])
    for g in role_groups:
        ous.add(g["ou"])
    # Les parents d'abord : tri par profondeur puis alphabétique.
    ordered = sorted(ous, key=lambda dn: (dn.count("DC=") - 1 + dn.count("OU="), dn))

    out = []
    a = out.append
    a("# Provisionnement de aiitops.local — genere depuis seed/ad_seed.json (seed %s)" % d.get("seed"))
    a("$ErrorActionPreference = 'Stop'")
    a("$ProgressPreference = 'SilentlyContinue'")
    a("$root = 'DC=aiitops,DC=local'")
    a("$pwdUser = ConvertTo-SecureString %s -AsPlainText -Force" % ps_str(users[0]["password"]))
    a("$t0 = Get-Date")
    a("Write-Host ''")
    a("Write-Host '=== provisionnement de aiitops.local ===' -ForegroundColor Cyan")
    a("")

    # ── OU ──
    a("# --- OU ---")
    a("$nOu = 0")
    a("foreach ($dn in @(")
    a(",\n".join("  " + ps_str(dn) for dn in ordered))
    a(")) {")
    a("  $exists = Get-ADOrganizationalUnit -Filter \"DistinguishedName -eq '$dn'\" -ErrorAction SilentlyContinue")
    a("  if (-not $exists) {")
    a("    $name = ($dn -split ',')[0] -replace '^OU=', ''")
    a("    $parent = ($dn -split ',', 2)[1]")
    a("    New-ADOrganizationalUnit -Name $name -Path $parent -ProtectedFromAccidentalDeletion $false")
    a("    $nOu++")
    a("  }")
    a("}")
    a("Write-Host ('[OU]      {0} unites d organisation' -f $nOu) -ForegroundColor Green")
    a("")

    # ── Utilisateurs ──
    a("# --- Utilisateurs nominatifs, OU par OU ---")
    a("$nUser = 0")
    by_ou = {}
    for u in users:
        by_ou.setdefault(u["ou"], []).append(u)
    for ou in sorted(by_ou):
        a("# %s" % ou)
        for u in by_ou[ou]:
            a("New-ADUser -Name %s -SamAccountName %s -UserPrincipalName %s "
              "-GivenName %s -Surname %s -DisplayName %s -Title %s -Department %s "
              "-Path %s -AccountPassword $pwdUser -Enabled $true -ChangePasswordAtLogon $false "
              "-HomeDrive %s -HomeDirectory %s -OfficePhone %s -Office %s" % (
                  ps_str(u["displayName"]), ps_str(sam(u["username"])), ps_str(sam(u["username"]) + "@" + d["domain"]),
                  ps_str(u["firstName"]), ps_str(u["lastName"]), ps_str(u["displayName"]),
                  ps_str(u["title"]), ps_str(u["department"]), ps_str(u["ou"]),
                  ps_str(u["homeDrive"]), ps_str(u["homeDirectory"]), ps_str(u["phone"]), ps_str(u["office"])))
            a("$nUser++")
        short = ou.split(",")[0].replace("OU=", "")
        a("Write-Host ('  {0,-20} {1,2} comptes' -f %s, %d)" % (ps_str(short), len(by_ou[ou])))
        if PAUSES:
            a("Start-Sleep -Milliseconds 220")
    a("Write-Host ('[USER]    {0} comptes nominatifs' -f $nUser) -ForegroundColor Green")
    a("")

    # ── Managers ──
    managers = [u for u in users if u.get("manager")]
    a("# --- Rattachements hierarchiques ---")
    for u in managers:
        a("Set-ADUser -Identity %s -Manager (Get-ADUser -Identity %s).DistinguishedName" % (
            ps_str(sam(u["username"])), ps_str(sam(u["manager"]))))
    a("Write-Host ('[HIER]    {0} rattachements manager' -f %d) -ForegroundColor Green" % len(managers))
    a("")

    # ── Comptes de service ──
    a("# --- Comptes de service ---")
    for s in svc:
        a("New-ADUser -Name %s -SamAccountName %s -Path %s -AccountPassword $pwdUser "
          "-Enabled $true -Description %s -PasswordNeverExpires $true" % (
              ps_str(s["displayName"]), ps_str(s["username"]), ps_str(s["ou"]), ps_str(s["description"])))
    a("Write-Host ('[SVC]     {0} comptes de service' -f %d) -ForegroundColor Green" % len(svc))
    a("")

    # ── Groupes ──
    a("# --- Groupes ---")
    for g in role_groups:
        a("New-ADGroup -Name %s -GroupScope %s -GroupCategory Security -Path %s" % (
            ps_str(g["name"]), g["scope"], ps_str(g["ou"])))
        for m in g.get("members", []):
            a("Add-ADGroupMember -Identity %s -Members %s" % (ps_str(g["name"]), ps_str(sam(m))))
    for g in res_groups:
        a("New-ADGroup -Name %s -GroupScope %s -GroupCategory Security -Path 'OU=Groupes,OU=TN,DC=aiitops,DC=local' "
          "-Description %s" % (ps_str(g["name"]), g["scope"], ps_str(g.get("description", ""))))
    a("Write-Host ('[GROUP]   {0} groupes, {1} appartenances' -f %d, %d) -ForegroundColor Green" % (
        len(role_groups) + len(res_groups), sum(len(g.get("members", [])) for g in role_groups)))
    a("")

    # ── Partages ──
    a("# --- Partages ---")
    a("$svc = Get-ADGroup -Filter \"Name -eq 'G_DSI_Admins'\"")
    for sh in d["shares"]:
        local = sh["localPath"].replace("E:\\Shares", SHARE_ROOT)
        a("$p = %s" % ps_str(local))
        a("if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }")
        for sub in sh.get("subdirs", []):
            a("if (-not (Test-Path (Join-Path $p %s))) { New-Item -ItemType Directory -Path (Join-Path $p %s) -Force | Out-Null }" % (
                ps_str(sub), ps_str(sub)))
        a("if (-not (Get-SmbShare -Name %s -ErrorAction SilentlyContinue)) { "
          "New-SmbShare -Name %s -Path $p -FullAccess 'Utilisateurs du domaine' | Out-Null }" % (
              ps_str(sh["name"]), ps_str(sh["name"])))
        for perm in sh.get("permissions", []):
            a("$d = Join-Path $p %s" % ps_str(perm["folder"]))
            a("$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("
              "%s, %s, 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl" % (
                  ps_str("AIITOPS\\" + perm["group"]), ps_str(perm["rights"])))
    a("")

    # ── Dossiers personnels ──
    home_share = next((s for s in d["shares"] if s["name"] == "Home"), None)
    if home_share:
        home_root = home_share["localPath"].replace("E:\\Shares", SHARE_ROOT)
        a("# --- Dossiers personnels ---")
        a("$h = %s" % ps_str(home_root))
        a("$nHome = 0")
        for u in users:
            a("$d = Join-Path $h %s" % ps_str(sam(u["username"])))
            a("if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }")
            a("$acl = Get-Acl $d; $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("
              "%s, 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow'))); Set-Acl $d $acl" % ps_str("AIITOPS\\" + sam(u["username"])))
            a("$nHome++")
        a("Write-Host ('[HOME]    {0} dossiers personnels' -f $nHome) -ForegroundColor Green")
        a("")

    # ── Résumé ──
    if PAUSES:
        a("Start-Sleep -Milliseconds 600")
    a("$dt = (Get-Date) - $t0")
    a("Write-Host ''")
    a("Write-Host ('=== termine en {0:N1} s ===' -f $dt.TotalSeconds) -ForegroundColor Cyan")
    a("'{0,-14} {1}' -f 'utilisateurs', (Get-ADUser -Filter * | Measure-Object).Count")
    a("'{0,-14} {1}' -f 'groupes',      (Get-ADGroup -Filter * | Measure-Object).Count")
    a("'{0,-14} {1}' -f 'OU',           (Get-ADOrganizationalUnit -Filter * | Measure-Object).Count")
    a("'{0,-14} {1}' -f 'partages',     (Get-SmbShare | Where-Object { $_.Name -notlike '*$' } | Measure-Object).Count")

    text = "\n".join(out) + "\n"
    if args.out:
        # l'entete ci-dessous remplace la premiere ligne du generateur
        if out and out[0].startswith("# Provisionnement"):
            out = out[1:]
        text = "\n".join(out) + "\n"
        header = [
            "# AD Seed pour aiitops.local — généré depuis ad_seed.json (SEED=%s)" % d.get("seed"),
            "# À exécuter sur un contrôleur de domaine déjà promu (voir promote_dc.ps1).",
            "# Crée les OU, les comptes, les groupes, les partages et les dossiers personnels.",
            "# Généré par seed/build_provision.py — ne pas éditer à la main.",
            "",
        ]
        data = b"\xef\xbb\xbf" + ("\n".join(header) + text).replace("\n", "\r\n").encode("utf-8")
        with open(args.out, "wb") as fh:
            fh.write(data)
        print(f"ecrit {args.out} ({len(data)} octets)")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
