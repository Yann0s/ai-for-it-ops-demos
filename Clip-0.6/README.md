# Clip 0.6 — Claude Code fait l'état des lieux du serveur 2022

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`, serveur 2022 = `192.168.10.241`).

## BandeSon
Claude Code fait l'état des lieux de Windows Server 2022 : il se connecte en ssh depuis le PC d'administration puis fait un inventaire rapide : hostname, adresse ipv4, espace disque libre, ports en ecoute, et les 5 derniers evenements systeme et application

## Prompt de départ

```
> L'agent fait l'état des lieux
  du serveur 2022, en ssh
  · ssh admin@192.168.10.241 (clé .ssh\demo)
  · os, ip, disque, ports, événements
  · aucune intervention sur le serveur
```

**Format :** 1080×1920 (9:16) · 24,0 s · H.264 · ~720 Ko
**Cible :** CLI-01 → serveur 2022 (`192.168.10.241`, Windows Server 2022)

## Ce que montre le clip

Une seule commande, en headless, sans autre outil que ceux du système :

```powershell
.\claude -p "connecte toi en ssh sur admin@192.168.10.241 avec la cle .ssh\demo, puis fais l etat des lieux : hostname, adresse ipv4, espace disque libre, ports en ecoute, et les 5 derniers evenements systeme et application" --dangerously-skip-permissions
```

| Relevé | Commande trouvée par l'agent | Résultat |
|---|---|---|
| Identité | `hostname`, `ipconfig` | `ADMINWI-3F0Q0C5`, `192.168.10.241/24`, passerelle `.254` |
| Disque | `fsutil volume diskfree c:` | ~68 Go libres sur 79,7 |
| Ports | `netstat -an` | SSH 22, RDP 3389, SMB 445, WinRM 5985 ouverts |
| Journaux | `wevtutil qe system /c:5` et `application /c:5` | aucun niveau erreur ou avertissement |
| Analyse | — | « SMB, RDP et WinRM ouverts : normal pour un serveur d'admin, mais vérifier que le pare-feu limite les ports au réseau d'administration » |

L'agent ne se contente pas d'exécuter : il hiérarchise. Il relève au passage que le
build 20348.587 est ancien et que Windows Update venait de démarrer — un point à
traiter avant de promouvoir la machine en contrôleur de domaine.

## Réalisation

Capture VNC (2 fps) pilotée par `claude-etat.timeline.json`, composition 9:16 via
`compose_short.py` + `claude-etat.spec.json`.

Trois réglages qui ont fait le clip :

- **Auth par clé, pas par mot de passe.** La clé `demo` de CLI-01 est déposée dans
  `C:\ProgramData\ssh\administrators_authorized_keys` côté serveur, avec l'ACL réduite
  à `Administrateurs` + `SYSTEM` (nom du groupe **localisé** en français) : sans ça
  sshd ignore le fichier. C'est ce qui permet à l'agent de se connecter sans jamais
  afficher de mot de passe à l'écran.
- **`--dangerously-skip-permissions`.** En headless, Claude Code refuse par défaut
  d'exécuter un outil (« a tool required the "command" permission that headless mode
  cannot prompt for »). Le drapeau est propre à l'agent : Antigravity utilise le même,
  Vibe utilise `--auto-approve`.
- **Cadrage.** Fenêtre ancrée sur une demi-écran, police réduite d'un cran : la réponse
  fait une trentaine de lignes sur ~935 px de haut, la bande n'en montre que ~745. Le
  crop `[700, 130, 1400, 875]` est calé pour garder visible la fin de la commande
  pendant la frappe **et** la conclusion de l'agent ; les deux dernières lignes sortent
  légèrement du cadre, le panneau du bas portant la synthèse.

## Contenu

- `scene-0.6-claude-etat-des-lieux.mp4` — le clip
- `claude-etat.timeline.json` — les actions et leurs timings
- `claude-etat.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
