# Clip 0.1 — Préparer une machine Windows 11 pour l'administration à distance

## BandeSon

On prépare un poste Windows 11 pour l'administration à distance. La machine est renommée CLI-01, le DNS est réparé pour retrouver l'accès à Internet, puis OpenSSH Server est installé et le service sshd démarre automatiquement. Le poste est prêt à être piloté en SSH.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`).

## Prompt de départ

```
> Prépare cette machine Windows 11 pour l'administration à distance
  · renomme-la CLI-01
  · répare le DNS et vérifie Internet
  · installe OpenSSH Server et démarre sshd
```

**Format :** 1080×1920 (9:16) · 46 s · H.264 · ~950 Ko
**Cible :** CLI-01, Windows 11 (Dockur / QEMU-KVM, macvlan `192.168.10.242`)

## Ce que montre le clip

| Étape | Commande | Résultat |
|---|---|---|
| Identité | `hostname` → `rename-computer -newname CLI-01 -force` | machine renommée `CLI-01` |
| Réseau | `ping microsoft.com` (échec) → `netsh interface ip set dns "Ethernet" static 1.1.1.1` → `ping` | DNS réparé, Internet OK |
| Accès distant | `add-windowscapability -online -name openssh.server~~~~0.0.1.0` | OpenSSH Server installé |
| Service | `start-service sshd` + `set-service sshd -startuptype automatic` + `get-service sshd` | `Running · OpenSSH SSH Server` |

## Réalisation

Capture VNC de la console (2 fps) pilotée par `cli01-ssh.timeline.json`, composition 9:16 via `compose_short.py` + `cli01-ssh.spec.json`, encodage ffmpeg (`setpts=0.16*PTS`, 30 fps). Timeline et spec sont incluses : la prise est rejouable à l'identique.

**Format aligné sur le clip 0.5** (homogénéité de la série) : panneau prompt 380 px / bande VM 980 px / panneau résultat 560 px, `prompt_rule: none` (pas de filet bleu sous la ligne de commande), `band_bg: #0c0c0c` (le fond de bande prend la couleur exacte du terminal, le letterbox disparaît), trois puces au lieu de quatre pour tenir dans le panneau 380 px.

Le clip est recomposé depuis **la prise d'origine** (frames `merged/`, 2 fps) : la scène n'a pas été rejouée sur la VM, qui porte désormais les trois CLI authentifiées. La fenêtre du terminal y est maximisée (1400 px de large) alors que celle du clip 0.5 est ancrée en demi-écran : le texte est donc rendu à ×1,07 ici contre ×1,54 sur le 0.5. Recadrage `[0, 40, 1010, 894]` — la largeur 1010 est la limite à ne pas dépasser, au-delà on coupe les lignes les plus longues (la barre de progression bleue d'`Add-WindowsCapability` va jusqu'à 1376 px).

## Contenu

- `scene-0.1-cli01-ssh.mp4` — le clip
- `cli01-ssh.timeline.json` — les actions et leurs timings
- `cli01-ssh.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
