# Clip 0.2 — Installer Claude Code sur le poste d'administration

## BandeSon

On installe Claude Code sur le poste d'administration Windows 11. L'installeur officiel est téléchargé avec curl, l'installation se lance, puis on vérifie la version installée. Premier agent prêt à piloter le lab depuis la ligne de commande.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`).

## Prompt de départ

```
> Installe Claude Code
  sur ce poste Windows 11
  · télécharge l'installeur officiel
  · lance l'installation
  · vérifie la version installée
```

**Format :** 1080×1920 (9:16) · 22,5 s · H.264 · ~305 Ko
**Cible :** CLI-01, Windows 11 (Dockur / QEMU-KVM, macvlan `192.168.10.242`)

## Ce que montre le clip

| Étape | Commande | Résultat |
|---|---|---|
| Téléchargement | `curl.exe -fsSL https://claude.ai/install.cmd -o cc.cmd` | installeur récupéré |
| Installation | `cc.cmd` | « Claude Code successfully installed! » |
| Version | `cd .local\bin` puis `claude --version` | `2.1.330 (Claude Code)` |

Le binaire s'installe dans `C:\Users\User01\.local\bin`, hors du `PATH` par défaut —
l'appel par chemin relatif évite de manipuler `PATH` (et le `%` qui colle le Shift en VNC).

## Réalisation

Capture VNC de la console (2 fps) pilotée par `claude-code.timeline.json`, composition
9:16 via `compose_short.py` + `claude-code.spec.json`, encodage ffmpeg
(`setpts=0.42*PTS`, 30 fps). Timeline et spec sont incluses : la prise est rejouable
à l'identique.

**Format aligné sur le clip 0.5** (homogénéité de la série) : panneaux 380 / 980 / 560 px,
`prompt_rule: none` (le filet bleu par défaut coupait la ligne de commande),
`band_bg: #0c0c0c` (le fond de bande prend le noir exact du terminal, le letterbox
disparaît), recadrage `[0, 40, 700, 520]` — largeur 700 px pour un zoom de ×1,54,
identique à la fenêtre demi-écran du 0.5. La composition est refaite depuis la prise
d'origine (`take-cc-trim/`, 108 frames), sans rejouer la scène sur la VM.

## Contenu

- `scene-0.2-claude-code.mp4` — le clip
- `claude-code.timeline.json` — les actions et leurs timings
- `claude-code.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
