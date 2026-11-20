# Pipeline de production vidéo (VNC → short 9:16)

Chaîne de capture utilisée pour les scènes de la chaîne **AI for IT & OPS** :
piloter une VM Windows (Dockur) via son VNC, capturer des frames, composer un
short vertical 1080×1920, exporter en MP4.

```
hôte Hermes ──SSH tunnel──► ubu1 ──VNC:5900──► conteneur Dockur ──► VM Windows
      │
      ├─ vncdotool  : frappes clavier/souris + capture PNG
      ├─ Pillow     : composition des panneaux (prompt / VM / résultat)
      └─ ffmpeg     : assemblage frames → MP4
```

## 1. Préparation (une fois)

```bash
# venv outil de capture
PY=$(echo /home/hermes/.hermes/tools/python-3.14.9*/bin/python3)
$PY -m venv ~/.hermes/cache/scratch/vmrec-venv
~/.hermes/cache/scratch/vmrec-venv/bin/pip install vncdotool

# police (l'hôte n'a pas /usr/share/fonts)
mkdir -p ~/.hermes/cache/scratch/fonts
cd ~/.hermes/cache/scratch/fonts
for f in DejaVuSansMono.ttf DejaVuSansMono-Bold.ttf; do
  curl -sL -o "$f" "https://cdn.jsdelivr.net/npm/dejavu-fonts-ttf@2.37.3/ttf/$f"
done

# tunnel VNC vers les conteneurs Dockur (IP conteneur, pas IP guest)
ssh -N -L 5902:192.168.10.243:5900 -L 5901:192.168.10.240:5900 yannos@ubu1
```

Repères réseau du lab : conteneur SRV-DC `.240` / guest `.241`,
conteneur CLI-01 `.243` / guest `.242`.

## 2. Préparer la VM avant la prise

- Déverrouiller la console (**pas en RDP** : une session RDP verrouille la
  console, le VNC ne montrerait que l'écran de login).
- Ouvrir le terminal **PowerShell en administrateur** à l'avance (`Win+X`).
- **Redimensionner la fenêtre en hauteur** (≈ 1000×900) : la fenêtre par défaut
  est très large et basse (≈ 1100×470), ce qui laisse de grandes bandes noires
  dans le montage vertical.
- Vérifier la propreté de l'écran (fermer les fenêtres parasites).

## 3. Capturer une prise

`capture_take.py` exécute une timeline d'actions en capturant en continu :

```bash
python capture_take.py ma_prise/ 120
```

Chaque action est planifiée en secondes et exécutée une seule fois. La cadence
réelle est ≈ 1,9 frame/s (capture PNG ≈ 0,3 s).

## 4. Composer le short

```bash
python compose_final.py <dossier_frames> <dossier_sortie> <image_finale> 12
ffmpeg -y -framerate 2 -i comp/f_%04d.png \
  -vf "setpts=0.42*PTS,fps=30" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -movflags +faststart \
  short.mp4
```

`setpts=0.42*PTS` compresse ≈ 100 s de capture réelle en ≈ 42 s de vidéo.

### Gabarit du montage (1080×1920)

| Bande | Hauteur | Contenu |
|---|---|---|
| Panneau prompt | 400 px | objectif en langage naturel + commande clé |
| Bande VM | 880 px | terminal recadré (`CROP`) sur fond noir `#0c0c0c` |
| Panneau résultat | 640 px | 3 vérifications + prochaine étape + signature |

Le fond de la bande VM est le **noir du terminal** : le letterbox devient
invisible et la fenêtre paraît occuper toute la bande.

## 5. Pièges (tous rencontrés en vrai)

### Layout clavier
Le VNC envoie des keycodes **US** ; un Windows en **AZERTY** les interprète
autrement. Mapping pour taper en AZERTY : `a→q`, `m→;`, `z→w`, `w→z`,
`-→6`, `'→4`, `=→8`. Le `~` s'obtient par **Shift+backtick** (jamais `ralt`,
qui n'est pas transmis). PowerShell étant insensible à la casse, taper les
commandes **en minuscules** évite les Shift résiduels (un Shift resté enfoncé
transforme le `-` suivant en `6`).

Mieux : passer la VM en clavier **US** (`Set-WinUserLanguageList en-US -Force`
puis reconnexion) — tout se tape alors directement.

### Login console
Un mot de passe avec chiffres/symboles est pénible à taper en VNC. Préférer
l'**autologin** :

```powershell
$k="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty $k AutoAdminLogon "1"
Set-ItemProperty $k DefaultUserName "User01"
Set-ItemProperty $k DefaultPassword "<mot de passe réel du snapshot>"
Set-ItemProperty $k DefaultDomainName $env:COMPUTERNAME
```

Attention : après une restauration de snapshot, le mot de passe est celui du
snapshot, pas celui changé depuis.

### API vncdotool
`mouseRelease` et `typeText` n'existent pas → `mouseUp(1)` et boucler
`keyPress(ch)`. `clientCutText` casse la connexion. Noms de touches utiles :
`enter`, `esc`, `space`, `super`, `shift`, `ralt`.

### Snapshot Dockur
```bash
docker compose stop cli-01
cd /vm-gold/dockur/cli-01 && qemu-img snapshot -a snapshot-Vierge data.qcow2
docker compose start cli-01
```

### DNS de la VM
Si le compose pointe le DNS vers un DC pas encore promu, la VM n'a plus de
résolution : `Add-WindowsCapability` reste bloqué à 0 %. Corriger avec
`netsh interface ip set dns "Ethernet" static 1.1.1.1` — et montrer ce
diagnostic, il est pédagogique.

### Installation longue
`Add-WindowsCapability -name OpenSSH.Server~~~~0.0.1.0` prend 40-90 s. Couper
la capture avant la fin donne l'impression que ça « gèle ». Prévoir la marge
dans la timeline (ou couper le temps mort au montage).
