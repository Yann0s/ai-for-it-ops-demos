# AI for IT & OPS — Maquettes Docker (Dockur)

**Deux VMs Windows reproductibles** pour les épisodes MCP : un **Server 2022** (futur DC) et un **Windows 11** (poste client), déployées via [Dockur](https://github.com/dockur/windows) en macvlan.

## Structure

```
ai-for-it-ops-demos/
├── docker/
│   ├── docker-compose.yml         ← les deux VMs + réseau macvlan
│   ├── setup-macvlan-shim.sh      ← script hôte (ubuntu1) pour joindre les conteneurs
│   └── oem-srv-dc/
│       └── install.bat            ← post-install Windows (WinRM, SSH, RDP)
├── seed/
│   ├── generate_ad_seed.py        ← générateur déterministe (SEED=42)
│   ├── ad_seed.json               ← spec AD (35 utilisateurs, 12 OUs, groupes…)
│   └── provision_ad.ps1           ← script PowerShell standalone
└── START_HERE.md                  ← ce fichier
```

## Prérequis sur ubuntu1

- Linux avec KVM (`/dev/kvm` accessible)
- Docker installé (`docker compose` fonctionnel)
- 128 Go de RAM (confort, les VMs prennent ~12 Go)
- Ports utilisés sur le LAN macvlan : 241-242 (IP), 8006 (console web par IP)

## Déploiement

```bash
# 1. Copier le dossier sur ubuntu1
scp -r ai-for-it-ops-demos/ user@ubu1:~/

# 2. Adapter l'interface réseau dans docker-compose.yml (parent: eno1 → votre iface)
#    Trouver l'interface : ip link show | grep -E "^[0-9]+: (en|eth)"
#    Adapter aussi setup-macvlan-shim.sh (HOST_IFACE)

# 3. Créer les dossiers de stockage et lancer
cd ~/ai-for-it-ops-demos/docker
mkdir -p srv-dc cli-01
chmod +x setup-macvlan-shim.sh
docker compose up -d
```

## Pendant le premier démarrage

Le premier lancement télécharge l'ISO Windows (~5-8 Go) et fait l'installation automatique (~15-20 min). Surveiller :

```bash
docker compose logs -f srv-dc
```

Console web (installation en cours) :
- **SRV-DC** : http://192.168.1.241:8006
- **CLI-01** : http://192.168.1.242:8006

Une fois l'installation terminée, l'`install.bat` s'exécute automatiquement (WinRM, SSH, RDP activés).

## Après le premier démarrage

```bash
# Rétablir la connectivité hôte → conteneurs
sudo ./setup-macvlan-shim.sh
```

Vérifications :

```bash
ping 192.168.1.241    # SRV-DC
ping 192.168.1.242    # CLI-01
```

## Accès

| Service | SRV-DC (192.168.1.241) | CLI-01 (192.168.1.242) |
|---|---|---|
| Console web | http://192.168.1.241:8006 | http://192.168.1.242:8006 |
| RDP | mstsc /v:192.168.1.241 | mstsc /v:192.168.1.242 |
| WinRM | `Enter-PSSession 192.168.1.241 -Credential (Get-Credential)` | — |
| SSH | `ssh Admin@192.168.1.241` | `ssh User01@192.168.1.242` |

**Comptes** : `Admin` / `MCPdemo2024!` (SRV-DC), `User01` / `MCPdemo2024!` (CLI-01)

## Flux de l'épisode « création de domaine AD via MCP »

1. `docker compose up -d` → les deux VMs démarrent (install.bat a déjà préparé SRV-DC)
2. L'agent lit `ad_seed.json` (spécification de l'annuaire)
3. L'agent, via MCP/WinRM sur SRV-DC :
   - Installe AD DS, promeut le DC, crée la forêt `aiitops.local`
   - Crée les OUs, utilisateurs, groupes et partages (contenu de `ad_seed.json`)
   - Configure le DNS (pointe SRV-DC vers lui-même)
4. L'agent joint CLI-01 au domaine `aiitops.local`
5. L'agent crée un utilisateur, se connecte sur CLI-01 en tant que cet utilisateur
6. 🎬 Capture vidéo

## Régénérer le seed AD

Modifier `seed/generate_ad_seed.py` (SEED, noms, effectifs) puis :

```bash
cd seed && python3 generate_ad_seed.py
```

Les fichiers `ad_seed.json` et `provision_ad.ps1` sont régénérés à l'identique.

## Nettoyage / reset

```bash
docker compose down -v
rm -rf srv-dc cli-01
# Relancer → VMs vierges, nouvel install
```