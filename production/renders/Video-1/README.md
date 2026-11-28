# Video-1 — Chapitre AD : construire un domaine Active Directory de zéro

## BandeSon

On construit un domaine Active Directory complet sur une maquette Dockur :
installation du rôle AD DS, création de la forêt `aiitops.local`, structuration
de l'annuaire de démonstration (OU `lab`, deux comptes, un groupe), renommage
du contrôleur en `SRV-DC` — l'annuaire suit — puis provisionnement de
l'annuaire d'entreprise en moins de six secondes (35 comptes, 15 groupes,
2 partages) depuis un seed déterministe.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance les prises et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre les scènes : tunnel VNC vers la maquette, pilote la console, capture les frames et compose le chapitre.
- **Dockur** (serveur Linux local, ubu1) — la maquette : conteneur QEMU/KVM, IP macvlan `192.168.10.241`.

## Prompt de départ

```
> ok, tu peux faire le chapitre AD, on va faire un autre essais de video,
  tu vas filmer en entier chacune des scenes, donc 3 scenes. On mettra
  des portions en accelere pour les zones ou il ne se passe rien.
```

**Format :** 1920×1080 (16:9, YouTube standard) · 5 scènes · **3 min 04,5 s** au total · H.264 faststart
**Cible :** SRV-DC, Windows Server 2022 (Dockur / QEMU-KVM, macvlan `192.168.10.241`)

## Les scènes

| # | Fichier | Scène | Durée | Taille |
|---|---|---|---|---|
| 1 | `ad-scene1.mp4` | Installer le rôle AD DS | 21,0 s | 539 Ko |
| 2 | `ad-scene2.mp4` | Promouvoir en contrôleur (`install-addsforest`) | 25,0 s | 1,2 Mo |
| 3 | `ad-scene3.mp4` | Structurer l'annuaire : OU, utilisateurs, groupe | 60,0 s | 1,3 Mo |
| 4 | `ad-scene4.mp4` | Renommer le serveur en SRV-DC | 38,0 s | 796 Ko |
| 5 | `ad-scene5.mp4` | Provisionner l'annuaire d'entreprise | 40,5 s | 1,0 Mo |
| — | `chapitre-ad-complet.mp4` | Les 5 scènes bout à bout | 3 min 04,5 s | 4,8 Mo |

## Réalisation

Chaque scène : capture VNC de la console (2 fps) pilotée par la timeline JSON,
composition 16:9 via `compose_wide.py` + la spec (panneau prompt 236 px /
bande VM 662 px / panneau résultat, `prompt_rule: none`), encodage ffmpeg
(`setpts`, 30 fps, faststart). La scène 4 traverse un redémarrage : deux prises
recollées par `compose_takes.py` (démarrage condensé 1/10). Le provisionnement
est **généré** depuis `seed/ad_seed.json` par `seed/build_provision.py`.

Specs et timelines sont incluses : les prises sont rejouables à l'identique
(`vm_capture.py <dir> <durée> <timeline>`, puis `make_video.sh`).
L'artefact HTML interactif du chapitre vit dans `production/artifacts/chapitre-ad.html`.

## Contenu

- `chapitre-ad-complet.mp4` — le chapitre complet
- `ad-scene1..5.mp4` — les scènes individuelles
- `specs/` — textes et cadrage de chaque composition
- `timelines/` — les actions et leurs timings (scène 4 : prises `4a` + `4b`)
- `README.md` — cette description
