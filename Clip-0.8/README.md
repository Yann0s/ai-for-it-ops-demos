# Clip 0.8 — Vibe (Mistral) fait l'état des lieux du serveur 2022

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN (CLI-01 = `192.168.10.242`, serveur 2022 = `192.168.10.241`).

## BandeSon

Mistral Vibe fait l'état des lieux de Windows Server 2022 : il se connecte en ssh depuis le PC d'administration puis fait un inventaire rapide : hostname, adresse ipv4, espace disque libre, ports en ecoute, et les 5 derniers evenements systeme et application C'est l'agent qui determine les commandes systemes a utiliser

## Prompt de départ

```
> L'agent fait l'état des lieux
  du serveur 2022, en ssh
  · ssh admin@192.168.10.241 (clé .ssh\demo)
  · os, ip, disque, ports, événements
  · aucune intervention sur le serveur
```

**Format :** 1080×1920 (9:16) · 24,0 s · H.264 · ~725 Ko
**Cible :** CLI-01 → serveur 2022 (`192.168.10.241`, Windows Server 2022)

## Ce que montre le clip

Troisième agent, même consigne, même serveur :

```powershell
.\vibe -p "connecte toi en ssh sur admin@192.168.10.241 avec la cle .ssh\demo, puis fais l etat des lieux : hostname, adresse ipv4, espace disque libre, ports en ecoute, et les 5 derniers evenements systeme et application" --auto-approve
```

| Relevé | Ce que produit Vibe |
|---|---|
| Identité et réseau | hostname et adresse IPv4 du serveur |
| Disque | espace libre du volume `C:` (~68 Go) |
| Ports | sockets en écoute |
| Journaux | les 5 derniers événements système **et** applicatif, en tableaux (`Date (UTC) · ID · Source · Événement`) |
| Sortie | un paragraphe **Résumé** final qui recapitule la machine et conclut : journaux sans erreur critique, services qui redémarrent, SPP qui planifie le redémarrage de la protection logicielle |

C'est le seul des trois qui termine par une synthèse rédigée en une phrase — l'agent
ne se contente pas de recracher les commandes.

## Réalisation

Capture VNC (2 fps) pilotée par `vibe-etat.timeline.json`, composition 9:16 via
`compose_short.py` + `vibe-etat.spec.json`.

- **Son drapeau diffère** : `--auto-approve` (et non `--dangerously-skip-permissions`,
  que la CLI rejette en `unexpected argument`). C'est le genre d'écart qui rend le
  comparatif utile.
- **Nommer l'utilisateur dans le prompt est obligatoire** : avec « connecte-toi en ssh
  sur 192.168.10.241 », Vibe choisit `root@192.168.10.241` (réflexe Unix) et reste
  bloqué sur un prompt de mot de passe. `admin@…` dans la consigne règle le problème.
- **`vibe` n'est pas sur le `PATH`** : binaire dans `%USERPROFILE%\.local\bin`, d'où le
  `.\`.
- **Cadrage** : identique aux clips 0.6 et 0.7 (moitié d'écran, police réduite, crop
  `[700, 130, 1400, 875]`) pour que les trois clips se montent côte à côte sans
  rupture visuelle.

## Contenu

- `scene-0.8-vibe-etat-des-lieux.mp4` — le clip
- `vibe-etat.timeline.json` — les actions et leurs timings
- `vibe-etat.spec.json` — textes et cadrage de la composition
- `README.md` — cette description
