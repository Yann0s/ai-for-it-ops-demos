# Clip 0.3 — Installer Antigravity CLI sur le poste d'administration

## BandeSon

On installe Antigravity CLI, l'agent de Google, sur le poste d'administration Windows 11. L'installeur officiel est téléchargé puis exécuté, et on vérifie que le binaire agy est bien en place. Deuxième agent prêt pour le lab.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`).

## Prompt de départ

```
> Installe Antigravity CLI
  sur ce poste Windows 11
  · télécharge l'installeur officiel
  · lance l'installation
  · vérifie le binaire installé
```

**Format :** 1080×1920 (9:16) · 18,5 s · H.264 · ~349 Ko
**Cible :** CLI-01, Windows 11 (Dockur / QEMU-KVM, macvlan `192.168.10.242`)

## Ce que montre le clip

| Étape | Commande | Résultat |
|---|---|---|
| Téléchargement | `curl.exe -fsSL https://antigravity.google/cli/install.cmd -o agy.cmd` | installeur récupéré |
| Installation | `agy.cmd` | « Antigravity CLI installed successfully » |
| Vérification | `cd appdata\local\agy\bin` puis `dir agy.exe` | `agy.exe` présent dans `AppData\Local\agy\bin` |

Le binaire s'installe dans `C:\Users\User01\AppData\Local\agy\bin`, hors du `PATH` par
défaut — d'où le `cd` avant le `dir`. L'installeur affiche lui-même le chemin à utiliser.

## Réalisation

Capture VNC de la console (2 fps) pilotée par `antigravity.timeline.json`, composition
9:16 via `compose_short.py` + `antigravity.spec.json`, encodage ffmpeg
(`setpts=0.40*PTS`, 30 fps). Timeline et spec sont incluses : la prise est rejouable
à l'identique.

Le panneau du haut utilise `"prompt_rule": "none"` : plus de filet bleu collé sous la
ligne de commande, qui se lisait comme une barre passant sur le texte. Le cadrage
`crop: [0, 0, 830, 470]` englobe la fenêtre entière sans couper la première ligne.

## Contenu

- `scene-0.3-antigravity.mp4` — le clip
- `antigravity.timeline.json` — les actions et leurs timings
- `antigravity.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
