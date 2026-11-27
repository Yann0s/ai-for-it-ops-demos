# Clip 0.4 — Installer Vibe (Mistral) sur le poste d'administration

## BandeSon

On installe Mistral Vibe sur le poste d'administration Windows 11. winget installe d'abord le gestionnaire uv, qui installe ensuite mistral-vibe avec Python 3.12, puis on vérifie la version de vibe. Troisième agent prêt pour le lab.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`).

## Prompt de départ

```
> Installe Vibe (Mistral)
  sur ce poste Windows 11
  · installe uv via winget
  · installe mistral-vibe
  · vérifie le binaire vibe
```

**Format :** 1080×1920 (9:16) · 24,5 s · H.264 · ~531 Ko
**Cible :** CLI-01, Windows 11 (Dockur / QEMU-KVM, macvlan `192.168.10.242`)

## Ce que montre le clip

| Étape | Commande | Résultat |
|---|---|---|
| Gestionnaire de paquets | `winget --version` | `v1.29.380` |
| Installation de uv | `winget install --id astral-sh.uv -e --accept-source-agreements --accept-package-agreements` | `Successfully installed`, alias `uv` / `uvx` / `uvw` |
| Contrôle | `uv --version` | `uv 0.13.9 (62b39dcc 2026-11-17 x86_64-pc-windows-msvc)` |
| Installation de Vibe | `uv tool install --python 3.12 mistral-vibe` | `Installed 3 executables: vibe, vibe-acp, vibe-app-server` |
| Vérification | `vibe --version` | `vibe 3.1.4` |

Vibe s'installe dans `C:\Users\User01\.local\bin`, avec trois exécutables (`vibe`,
`vibe-acp`, `vibe-app-server`). uv le signale : ce dossier n'est pas dans le `PATH` de
la session, d'où le `vibe --version` lancé depuis le dossier courant.

`--python 3.12` n'est pas décoratif : avec le Python par défaut (3.15) `tree-sitter`
n'a pas de wheel et uv tente de le compiler, ce qui échoue en
`error: Microsoft Visual C++ 14.0 or greater is required`. Forcer 3.12 prend les
wheels précompilés et l'installation passe sans chaîne de compilation.

## Réalisation

Capture VNC de la console (2 fps) pilotée par `vibe.timeline.json`, composition 9:16
via `compose_short.py` + `vibe.spec.json`, encodage ffmpeg (`setpts=0.42*PTS`, 30 fps).

L'installation de `mistral-vibe` dure plusieurs minutes sur ce poste (téléchargement
d'une centaine de paquets) : la prise est donc faite en deux temps. Le premier take
(`vibe.timeline.json`) va du `cls` jusqu'au démarrage de `uv tool install` ; le second
(`vibe-final.timeline.json`) est lancé une fois l'installation terminée et ne rejoue
que `vibe --version`. Les frames des deux prises sont mises bout à bout avant
composition — le raccord tombe sur la fin de l'installation et se lit comme un
raccourci, pas comme une coupure.

Deux détails de prise :

- **Tout en minuscules.** QEMU garde un Shift « fantôme » quand on lui envoie un
  `keyUp` sans `keyDown` : la suite de la commande sort alors en MAJUSCULES, et
  `--id` devient `--ID`, que winget refuse. Le clavier est remis à zéro par une paire
  `shift` down/up complète au début de la prise, et plus aucun `keyUp` isolé n'est
  envoyé pendant la frappe.
- **Cadrage plein cadre.** `crop: [0, 60, 1120, 985]` : la fenêtre du terminal remplit
  la bande vidéo (rapport aligné sur 1080×980), sans barre des tâches ni barre
  d'onglets, et la ligne `winget install …` tient entière. `"prompt_rule": "none"`
  pour ne pas coller de filet bleu sous la ligne de commande.

## Contenu

- `scene-0.4-vibe-mistral.mp4` — le clip
- `vibe.timeline.json` — les actions et leurs timings (prise principale)
- `vibe-final.timeline.json` — la prise de clôture (`vibe --version`)
- `vibe.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
