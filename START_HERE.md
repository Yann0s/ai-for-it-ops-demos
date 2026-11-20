# AI for IT & OPS — Maquettes Docker (Dockur)

**Deux VMs Windows reproductibles** pour les épisodes MCP : un **Server 2022** (futur DC) et un **Windows 11** (poste client), déployées via [Dockur](https://github.com/dockur/windows) en macvlan.  

Notes Personnelles : convertion du fichier image, snapshot ...  

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
**sudo ./setup-macvlan-shim.sh**
```

Vérifications :

```bash
ping 192.168.1.241    # SRV-DC
ping 192.168.1.242    # CLI-01
```
_____  
**⚠ Ce setup n'est PAS persistant au reboot. Pour le rendre permanent :**  
   → ajouter dans /etc/network/interfaces ou un service systemd  
   → ou relancer ce script après reboot  

sudo ./setup-macvlan-shim.sh  
Création de l'interface shim macvlan-host sur br0...  
✓ Interface shim active. ce host peut maintenant joindre les conteneurs.  
  Ping DC  : ping 192.168.10.241  
  Ping Win11: ping 192.168.10.242  
  Console DC web : http://192.168.10.241:8006  
  **RDP Activé :**  
  SRV-DC         : mstsc /v:192.168.10.241 ou Remmina  
  CLI-01         : mstsc /v:192.168.10.242 ou Remmina  
_____  

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

## Notes Personnelles  
### Convertion du fichier image de l'OS:  
Convertir data.img vers data.qcow2 :  

```bash
qemu-img convert -c -O qcow2 path/to/windows/data.img some_path/my_windows_version.qcow2
```

### Realiser les Snapshots :  
#### Sur VM / Conteneur éteint (docker compose stop)
Creer un snapshot:  
qemu-img snapshot -c snapshot_name data.qcow2

Restaurer un snapshot:  
qemu-img snapshot -a snapshot_name data.qcow2

Supprimer un snapshot:  
qemu-img snapshot -d snapshot_name data.qcow2

Lister les snapshots:  
qemu-img snapshot -l data.qcow2  


Pour faire les memes operations sur machine allumée, il faut se connecter au port de monitoring de QEMU:  

```bash
# Dans docker-compose.yml
environment:
  MONITOR: "telnet:0.0.0.0:7777,server,nowait,nodelay"
  HOST_PORTS: "7777"
```  

#### En utilisant le port de monitoring de QEMU:  
En se connectant sur le port 7777 du conteneur via telnet,
on peut utiliser les commandes suivantes:  

Creer un snapshot machine virtuelle complete:  
savevm nom_du_snapshot

Restorer la machine virtuelle depuis le snapshot:  
loadvm nom_du_snapshot

Supprimer le snapshot:  
delvm nom_du_snapshot

