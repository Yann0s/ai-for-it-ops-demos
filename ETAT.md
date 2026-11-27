# État des lieux — projet « AI for IT & OPS »

> Fichier de reprise. Écrit le 27 novembre 2026 pour permettre de changer de modèle
> ou de reprendre la session sans rien perdre. Tout ce qui suit est vérifié, pas déduit.
> Les chiffres viennent de `ffprobe`, de mesures au pixel et de sorties de commandes.

---

## 1. Le projet en trois lignes

Chaîne YouTube « AI for IT & OPS » : montrer comment des agents IA pilotent une
infrastructure réelle (Active Directory, Windows Server, hyperviseurs) via MCP.
Format **16:9 / 1920×1080**, pas de short. Chaque scène est filmée sur une vraie VM,
composée avec des panneaux (question en haut, console au milieu, résultats en bas),
puis encodée. Tout est reproductible depuis des fichiers de spec JSON.

Dépôt : `github.com/Yann0s/ai-for-it-ops-demos` (privé), clone sur le VPS dans
`~/ai-for-it-ops-demos`, branche `main`.

---

## 2. Le lab

| Rôle | Hôte | Adresse | Notes |
|---|---|---|---|
| VPS Hermes | `ryna07` | 100.86.98.63 (tailnet) | héberge le clone git, les rendus, le serveur HTTP |
| Hôte KVM | `ubu1` | 100.109.58.79 (tailnet), user `yannos` | Docker + Dockur, stockage `/vm-gold`, **Xorg :0 + lightdm**, OBS 32.2.0 |
| Conteneur DC | `srv-dc` | 192.168.10.240 | VM Windows Server 2022 → **192.168.10.241** |
| Conteneur DC 2 | `srv-dc2` | 192.168.10.244 | VM Windows Server 2022 → **192.168.10.245**, disque **qcow2 80G** (`DISK_FMT`), OEM `docker/oem-srv-dc2/` |
| Conteneur client | `cli-01` | 192.168.10.243 | VM Windows 11 → 192.168.10.242 |

- Domaine : **`aiitops.local`**, **deux contrôleurs** : `SRV-DC` (PDC, tous les FSMO)
  et `SRV-DC2` (promu à l'antenne, `install-addsdomaincontroller`, DNS installé).
  Réplication vérée 0 échec dans les deux sens après chaque cycle.
- VNC : tunnel SSH depuis ubu1, `-L 5901:192.168.10.240:5900` (SRV-DC),
  `-L 5903:192.168.10.244:5900` (SRV-DC2).
- Console SRV-DC2 : compte **de domaine** après promotion (`aiitops\admin`,
  profil `C:\Users\Admin.AIITOPS`) — registre console et profil d'auto-placement
  ré-appliqués pour CE profil ; clavier US posé par `Set-WinUserLanguageList`
  (0409:00000409, UI reste française), effectif après reboot.
- IPv6 : **RouterDiscovery ET Dhcp désactivés** sur les deux DC (le DHCPv6 du
  routeur ré-inscrit des AAAA publiques même avec RouterDiscovery coupé) ;
  0 AAAA dans les zones `aiitops.local` / `_msdcs` après nettoyage.
- Le mot de passe du lab est dans `seed/ad_seed.json` (champ `password`).
- `/vm-gold` : 636 G, ~93 G libres ; disque srv-dc2 en qcow2 (~7 Go écrits).

### État réel de l'annuaire (vérifié après la scène 5)

```
utilisateurs 44   (35 nominatifs + 3 de service + 6 par défaut)
groupes      64   (8 groupes de rôle + 7 de ressource + 49 système)
OU           17   (15 du seed + Domain Controllers + lab)
partages     Home=C:\Shares\Home   Services=C:\Shares\Services
dossiers     35 sous C:\Shares\Home
hôte         SRV-DC · domaine aiitops · PDC Emulator SRV-DC.aiitops.local
```

L'OU `lab` (scène 3) contient `alice.martin`, `bob.dupont` et `grp-helpdesk`.

### Prises brutes du déploiement srv-dc2 (à monter)

| Prise | Où | Contenu |
|---|---|---|
| `/vm-gold/frames-srvdc2` (ubu1) | 83 frames 1280×800 | install Dockur passive (ISO, setup, install.bat) |
| `/tmp/f6b` | 599 frames 1920×1080 | promotion : feature + `install-addsdomaincontroller`, reboot |
| `/tmp/f7b` | 85 frames | vérification : 2 DC, `repadmin /replsummary` 0 échec, FSMO |
| `/tmp/f8a` | 48 frames | MMC ADUC → OU Domain Controllers (SRV-DC + SRV-DC2) |
| `/tmp/f8d` | 59 frames | MMC DNS sur SRV-DC2 (SOA servi, 2 NS, A .241/.245) |
| `/tmp/f9c` | 57 frames | résilience : arrêt conteneur srv-dc, le domaine répond via SRV-DC2 |

La première tentative de promotion (`/tmp/f6`) s'est soldée par le piège
AAAA/IPv6 (voir section pièges) — elle n'est pas à monter.

---

## 3. Ce qui est produit (mesuré)

| Fichier | Durée | Taille | Bande console |
|---|---|---|---|
| `production/renders/ad-scene1.mp4` | 21,0 s | 539 132 o | 635 px (ancienne) |
| `production/renders/ad-scene2.mp4` | 25,0 s | 1 182 203 o | 635 px (ancienne) |
| `production/renders/ad-scene3.mp4` | 60,0 s | 1 312 396 o | 662 px |
| `production/renders/ad-scene4.mp4` | 38,0 s | 795 954 o | 662 px |
| `production/renders/ad-scene5.mp4` | 40,5 s | 1 003 204 o | 662 px |
| `production/renders/chapitre-ad-complet.mp4` | **184,5 s** | 4 830 437 o | concaténation sans réencodage |

**Dette visuelle connue** : les scènes 1-2 ont une bande de 635 px, les scènes 3-5 de
662 px. Un saut de 27 px au montage entre la 2 et la 3. Corriger exige de refilmer 1-2,
donc de démoter le DC : décision reportée.

Artefacts HTML (autonomes, dans `production/artifacts/`) :
- `chapitre-ad.html` — lecteur du chapitre + accès aux 5 scènes (chemins relatifs,
  se sert à côté des MP4)
- `panorama-mcp.html` — 12 serveurs MCP Windows/AD, 3-5 outils retenus par projet
- `six-mois-mcp.html` — 31 dépôts MCP sur 7 domaines, cap éditorial, roadmap 6 mois,
  état de la chaîne de production

---

## 4. Valeurs calibrées — ne pas les réinventer

**Console Windows (scènes 3-5)** — registre `HKCU:\Console` + les deux clés par
application (`%SystemRoot%_System32_…` et `…_SysWOW64_…`) :

```
FontSize         = 0x002D0000   (Consolas 45 px)
WindowSize       = 0x000E0057   (14 lignes × 87 colonnes)
ScreenBufferSize = 0x03200057   (800 lignes)
ScrollBar        = 0            (pas de barre : largeur déterministe)
```

Fenêtre collée en (0,0) par une tâche planifiée `placewin` (session interactive).
Zone client mesurée : **x 8..1834, y 31..660 → 1827 × 630**.

**Spec de composition** (`production/specs/ad-scene{3,4,5}.json`) :

```json
"crop": [8, 31, 1835, 661],
"layout": { "prompt_h": 236, "vm_h": 662 }   // résultat = 182 px
```

Le texte arrive à ~22,07 px par caractère dans la vidéo — identique aux scènes 1-2
malgré des fenêtres différentes, parce que les deux remplissent 1920 px avec 87 colonnes.

**Encodage** : `-framerate 2` en entrée, `setpts=SPEED*PTS`, `fps=30`, libx264 crf 20,
yuv420p, `+faststart`. Vitesse appliquée : 1,3 sur la scène 5, 1,55 sur la 3, 0,8 sur la 4.

---

## 5. Les scripts et leur rôle

Dans `production/` :

| Script | Rôle |
|---|---|
| `vm_capture.py` | pilote la VM par VNC, joue une timeline JSON, capture les frames (~1,3–1,9 fps) |
| `compose_wide.py` | compose 1920×1080 : panneau + bande console + résultats, depuis une spec JSON |
| `compose_takes.py` | recolle deux prises séparées par un redémarrage (maintien + démarrage échantillonné) |
| `make_video.sh` | compose puis encode : `./make_video.sh <spec> <frames> <out.mp4> [speed]` |
| `compose_short.py`, `make_short.sh` | variante 9:16 historique, conservée |

Dans `seed/` :

| Script | Rôle |
|---|---|
| `generate_ad_seed.py` | génère `ad_seed.json` (SEED=42, déterministe) puis appelle le suivant |
| `build_provision.py` | génère `provision_ad.ps1` : `--out` (BOM UTF-8 + CRLF), `--pauses` (capture) |
| `promote_dc.ps1` | installe AD DS et crée la forêt (redémarre) |
| `provision_ad.ps1` | OU, 35 comptes + 3 de service, 15 groupes, 2 partages, 35 dossiers |

**Outils jetables, dans `/tmp` (perdus au prochain nettoyage — à committer un jour
dans `tools/`)** :
- `srvdc.py` (sur ubu1) — exécute une commande sur la VM par SSH/paramiko
- `put.py` (sur ubu1) — dépose un fichier sur la VM par SFTP
- `psrun.py` (sur le VPS) — encode un `.ps1` en base64 UTF-16 et l'exécute via `srvdc.py`,
  ce qui évite tout conflit de guillemets à travers ssh → bash → paramiko
- `vncu.py` — frappe VNC (space/enter/tab uniquement, le reste en keysym brut)

Sur la VM, `C:\temp\` contient `provision.ps1`, `placewin.ps1`, les scripts de police console.

---

## 6. Décisions prises, et pourquoi

- **16:9 plutôt que 9:16** : demande explicite, format YouTube standard.
- **`fit_band` ajuste par la largeur, rogne en bas** : un ajustement par la hauteur
  rognait les côtés et tronquait `PS C:\Users\Admin>` en `S C:\Users\Admin>`.
- **Crop mesuré sur la fenêtre, pas sur l'écran** : exclut la barre de titre et la barre
  de défilement, qui laissaient un liseré clair.
- **`windows-mcp` en épisode 1** : c'est le seul serveur MCP qui couvre
  AD DS + DNS + DHCP + AD CS et qui sait promouvoir un DC — la trame du chapitre rejouée.
- **Scripts PowerShell générés, jamais écrits à la main** : le seed change, le script suit.
- **`promote_dc.ps1` séparé de `provision_ad.ps1`** : `Install-ADDSForest` redémarre la
  machine avant la suite du script.

---

## 7. Pièges déjà payés — ne pas les repayer

1. **`Get-ADOrganizationalUnit -Identity` lève une exception terminale** malgré
   `-ErrorAction SilentlyContinue`. Utiliser `-Filter "DistinguishedName -eq '...'"`.
2. **Supprimer une OU échoue en « Accès refusé »** : le compte `admin` est propriétaire
   mais pas membre d'« Admins du domaine ». Ajouter une ACE `Delete,DeleteTree` sur l'OU,
   puis supprimer.
3. **Un `.ps1` sans BOM est lu en Windows-1252** par PowerShell 5.1 : « Comptabilité »
   devient « ComptabilitǸ » dans l'annuaire. Toujours écrire en UTF-8 **avec BOM**.
4. **AD refuse un SamAccountName accentué** : `élambert` → `elambert`.
5. **Le seed référence trois OU absentes de sa liste** (Infrastructure, Support,
   Développement) : les déduire des chemins réels des objets.
6. **Pas de lecteur E:** sur la VM : les partages du seed vont dans `C:\Shares`.
7. **Les polices du cache scratch sont purgées** : `compose_wide.py` retombe alors sur la
   police de secours de Pillow, les ✓ et → sortent en rectangles vides. Réinstaller
   DejaVu Sans Mono dans `~/.hermes/cache/scratch/fonts`.
8. **Le premier tiers des frames contient la scène précédente** : `clear-host` n'agit
   qu'après ~1 s. Couper les 3 premières frames avant composition.
9. **La commande de renommage n'apparaît qu'une frame** : le redémarrage suit l'Entrée.
   Dupliquer la frame pour la maintenir ~4 s au montage.
10. **QEMU garde un Shift fantôme** : purger par un cycle `keyDown/keyUp('shift')` avant
    de taper ; les majuscules passent par keysym, pas par Shift.
11. **`taskkill /F /IM powershell.exe` avant une prise** : évite les fenêtres résiduelles
    qui se superposent et cassent le cadrage.
12. **`pkill -f "<motif>"` peut tuer son propre shell** si le motif figure dans la ligne
    de commande.

---

## 8. Ce qui reste à trancher (état de la réflexion)

**Filmer l'hôte Linux et les interfaces graphiques.** Trois sources possibles, deux
régimes de capture :

- **Console / texte** → framebuffer VNC direct (1:1, déterministe, déjà calibré).
  C'est ce qui a produit les 5 scènes.
- **Interface graphique** (ADUC, DNS, DHCP, GPMC, AD CS…) → l'enregistrement temps réel
  à 25-30 fps reste nécessaire, mais pour **une seule raison : la cadence**. Le pointeur,
  lui, n'est pas un problème — voir la vérification ci-dessous.
- **Hôte Linux** → `ffmpeg -f x11grab` (ou OBS) sur `:0`.

RDP (Remmina) apporte : géométrie exacte 1920×1080, 30 fps, session
séparée. Coût : chaîne RDP → rendu → capture, acceptable seulement en plein écran 1:1.

**Vérifié le 27/11 — le curseur EST dans le framebuffer.** Deux screendumps QEMU
pris avec la souris en (1500, 400) puis (400, 800) diffèrent d'exactement 288 pixels,
sur une boîte englobant les deux positions du curseur ; les captures vncdotool montrent
le même compte. Donc : la capture VNC affiche le curseur, et n'importe quelle méthode de
capture du framebuffer aussi. La seule limite d'une démo graphique filmée par VNC est le
débit (1,3 fps), pas le curseur. Protocole de re-vérification : déplacer la souris entre
deux screendumps et comparer — si les captures sont identiques, le curseur a disparu.

**Vérifié le 27/11 — la session X d'ubu1 est en 2560×1440** (HDMI-0, primaire,
59,95 Hz ; `xrandr --query` sans sudo, avec `DISPLAY=:0`). 1920×1080 est un mode
disponible de l'écran. Deux options pour filmer en 1080p propre : capturer une
**région** de 1920×1080 (`x11grab -video_size 1920x1080 -i :0.0+0,0`) sans toucher à
la résolution de l'utilisateur, ou basculer l'écran en 1920×1080 pendant la prise
(`xrandr -s 1920x1080`) — intrusif puisque la machine sert aussi de poste.

**Évolutions que cela impose** : `compose_wide.py` doit accepter un paramètre `fps`
(30 pour les scènes graphiques) et des **plans** (intervalles avec cadrage/zoom) — une
fenêtre de propriétés filmée à l'échelle 100 % est illisible sur téléphone.

**OBS sur ubu1** : 32.2.0 installé, Xorg `:0` + lightdm, `/dev/dri` (VAAPI), PipeWire.
`obs-websocket` présent port 4455 mais **`server_enabled: false`** — un interrupteur à
basculer. Vérifié : utilisateur connecté, la machine sert de serveur Docker/KVM/stockage.

**Second contrôleur de domaine** : envisagé. Ce serait `Install-ADDSDomainController`
(rejoindre, répliquer, second DNS/GC), pas `Install-ADDSForest`. Démo de résilience :
couper SRV-DC et montrer que le domaine répond. À noter honnêtement à l'antenne si les
deux DC vivent sur le même hôte physique.

**Vérifié le 27/11** (voir ci-dessus) : la résolution de la session X d'ubu1, et le
comportement du curseur dans un `screendump` QEMU. Il reste à mesurer le débit réel
d'une capture VNC accélérée (client plus serré que vncdotool) avant de choisir entre
VNC et RDP pour les scènes graphiques.

---

## 9. Reprendre le travail

```bash
# tunnel VNC vers SRV-DC
ssh -f -N -L 5901:192.168.10.240:5900 yannos@100.109.58.79

# capturer une scène (timeline JSON)
cd ~/ai-for-it-ops-demos/production
VNC_HOST=localhost::5901 ~/.hermes/cache/scratch/vmrec-venv/bin/python \
  vm_capture.py /tmp/f5 75 timelines/ad-scene5.json

# composer + encoder
./make_video.sh specs/ad-scene5.json /tmp/f5 renders/ad-scene5.mp4 1.3

# servir les rendus et les artefacts sur le tailnet
cd renders && python3 serve.py 100.86.98.63 8099
```

Le venv de capture (`~/.hermes/cache/scratch/vmrec-venv`) est recréé par
`python3 -m venv` + `pip install vncdotool pillow` ; il est purgé avec le cache.

---

## 10. Roadmap validée (six mois)

Décembre : consolider l'AD (chapitre + `windows-mcp`). Janvier : Linux, l'accès SSH.
Février : Proxmox. Mars : sécurité (Wazuh). Avril : VMware. Mai : XCP-ng.

Détail et justification dans `production/artifacts/six-mois-mcp.html`.
