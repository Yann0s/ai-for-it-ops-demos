# Clip 0.7 — Antigravity CLI fait l'état des lieux du serveur 2022

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`, serveur 2022 = `192.168.10.241`).

## BandeSon

Antigravity fait l'état des lieux de Windows Server 2022 : il se connecte en ssh depuis le PC d'administration puis fait un inventaire rapide : hostname, adresse ipv4, espace disque libre, ports en ecoute, et les 5 derniers evenements systeme et application C'est l'agent qui determine les commandes systemes a utiliser

## Prompt de départ

```
> L'agent fait l'état des lieux
  du serveur 2022, en ssh
  · ssh admin@192.168.10.241 (clé .ssh\demo)
  · os, ip, disque, ports, événements
  · aucune intervention sur le serveur
```

**Format :** 1080×1920 (9:16) · 24,0 s · H.264 · ~1,2 Mo
**Cible :** CLI-01 → serveur 2022 (`192.168.10.241`, Windows Server 2022)

## Ce que montre le clip

Même consigne que les clips 0.6 et 0.8, même serveur, même clé :

```powershell
agy -p "connecte toi en ssh sur admin@192.168.10.241 avec la cle .ssh\demo, puis fais l etat des lieux : hostname, adresse ipv4, espace disque libre, ports en ecoute, et les 5 derniers evenements systeme et application" --dangerously-skip-permissions
```

| Relevé | Ce que produit Antigravity |
|---|---|
| Identité et réseau | hostname et adresse IPv4 du serveur, en clair |
| Disque | espace libre du volume `C:` |
| Ports | sockets en écoute |
| Journaux | les 5 derniers événements système **et** applicatif, présentés en tableaux Markdown (`Date / Heure · ID · Niveau · Source · Message`) |
| Sortie | `Connexion SSH réussie sur admin@192.168.10.241 avec la clé [demo]` — l'agent nomme lui-même la clé qu'il a utilisée |

C'est le clip où la mise en forme est la plus « rédigée » : Antigravity rend les
événements en tableaux, ce qui remplit vite l'écran et donne un rendu très
« rapport » — au prix de lignes qui débordent du cadre et d'un défilement rapide.

## Réalisation

Capture VNC (2 fps) pilotée par `agy-etat.timeline.json`, composition 9:16 via
`compose_short.py` + `agy-etat.spec.json`.

- **Même drapeau que Claude Code** : `--dangerously-skip-permissions`. Sans lui,
  l'agent répond `jetski: no output produced – a tool required the "command"
  permission that headless mode cannot prompt for`.
- **`agy` est sur le `PATH`** (l'installeur l'y ajoute), contrairement à `claude` et
  `vibe` qui vivent dans `.local\bin` : d'où l'absence de `.\` devant la commande.
- **Cadrage** : fenêtre ancrée sur une moitié d'écran, police réduite, crop
  `[700, 130, 1400, 875]`. La fenêtre fait ~935 px de haut et la réponse ~950 px :
  aucun cadrage ne montre les deux extrémités. Le crop est calé pour garder visible
  la fin de la commande pendant la frappe **et** la conclusion de l'agent — les deux
  dernières lignes du rapport sortent légèrement du cadre, le panneau du bas portant
  la synthèse.

## Contenu

- `scene-0.7-antigravity-etat-des-lieux.mp4` — le clip
- `agy-etat.timeline.json` — les actions et leurs timings
- `agy-etat.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
