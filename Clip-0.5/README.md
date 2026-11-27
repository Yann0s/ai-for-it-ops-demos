# Clip 0.5 — Trois agents, la même question

## BandeSon

Trois agents, la même question. Claude Code, Antigravity et Mistral Vibe répondent en mode headless à la même demande : un contrôleur de domaine en dix mots. Trois réponses courtes et justes, qui prouvent que chaque agent est bien authentifié et accède à son modèle.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`).

## Prompt de départ

```
> Trois agents, la même question
  sur ce poste Windows 11
  · claude code · antigravity · vibe
  · même question, trois réponses
  · mode headless (-p)
```

**Format :** 1080×1920 (9:16) · 36,5 s · H.264 · ~784 Ko
**Cible :** CLI-01, Windows 11 (Dockur / QEMU-KVM, macvlan `192.168.10.242`)

## Ce que montre le clip

La même question, posée en mode headless aux trois agents CLI installés sur le poste :

> `un controleur de domaine en 10 mots`

| Agent | Commande | Réponse |
|---|---|---|
| Claude Code 2.1.330 | `.\claude -p "un controleur de domaine en 10 mots"` | « Serveur Active Directory qui authentifie les utilisateurs et gère l'accès. » |
| Antigravity CLI 1.5.14 (Google AI Pro) | `agy -p "un controleur de domaine en 10 mots"` | « Serveur central qui authentifie les utilisateurs et contrôle leurs accès. » |
| Vibe 3.1.4 (clé API Mistral) | `.\vibe -p "un controleur de domaine en 10 mots"` | « Serveur qui stocke l'annuaire et authentifie les utilisateurs réseau. » |

Les trois réponses arrivent en deux lignes chacune : c'est ce qui rend le comparatif
lisible en vertical, et ce qui prouve que l'authentification fonctionne réellement —
un `--version` ne dit rien de l'accès au modèle, une réponse si.

Deux détails de chemins, qui cassent la prise si on les oublie :

- `agy` est **sur le PATH** (installé dans `AppData\Local\agy\bin` par son installeur) ;
- `claude` et `vibe` vivent dans `%USERPROFILE%\.local\bin`, **hors PATH** — d'où le
  `.\` devant les deux autres, la console étant déjà placée dans ce dossier.

Vibe affiche au passage `Reading API keys from the system keyring` : la clé Mistral
est dans le Windows Credential Manager, pas dans une variable d'environnement.

## Réalisation

Capture VNC de la console (2 fps) pilotée par `agents-compare.timeline.json`,
composition 9:16 via `compose_short.py` + `agents-compare.spec.json`, encodage ffmpeg
(`setpts=0.42*PTS`, 30 fps).

Deux réglages ont fait la lisibilité du clip :

- **Fenêtre ancrée à demi-écran gauche** (`Win+←`) plutôt que maximisée. Maximisée sur
  1400 px, les réponses s'étalent sur ~150 colonnes : recadrées en 9:16, le texte
  devient deux fois plus petit. Ancrée à 700 px, les réponses se replient sur ~46
  colonnes et tiennent en deux lignes, avec un texte 1,5× plus grand à l'écran.
- **Crop au rapport exact de la bande** : `[0, 48, 700, 683]` (700×635, rapport 1,10
  comme 1080/980). La bande vidéo est donc pleine, sans fond perdu ni bande de papier
  peint sur le bord droit — le piège quand on croppe une fenêtre non maximisée.

Toutes les commandes sont tapées **en minuscules**, apostrophes et guillemets compris :
un keysym majuscule laisse QEMU avec un Shift fantôme et la fin de la ligne part en
MAJUSCULES (voir le piège correspondant dans le skill `vm-screen-recorder`).

## Contenu

- `scene-0.5-trois-agents.mp4` — le clip
- `agents-compare.timeline.json` — les actions et leurs timings
- `agents-compare.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
