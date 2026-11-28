# Video-2 — Chapitre srv-dc2 : le deuxième contrôleur de domaine

## BandeSon

Dockur déploie un second Windows Server 2022 (disque 80 Go en **qcow2**,
growable, prêt pour les snapshots) pendant que la capture tourne seule.
La machine est renommée `SRV-DC2` hors caméra, puis la promotion est filmée :
`install-addsdomaincontroller` joint le domaine `aiitops.local` et installe le
DNS, avec des identifiants pré-étapés en DPAPI — aucun mot de passe à l'écran.
Vérification : deux contrôleurs, réplication 0 échec, FSMO sur `SRV-DC`.
Place aux MMC : l'OU « Domain Controllers » listant les deux serveurs, puis le
Gestionnaire DNS montrant la zone servie par les deux DC. Enfin la résilience :
on coupe le conteneur du premier DC en pleine vie, le domaine continue de
répondre via `SRV-DC2`.

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance les prises et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre les scènes : tunnel VNC vers la maquette, pilote la console, capture les frames et compose le chapitre.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : `srv-dc2` = conteneur QEMU/KVM `192.168.10.244`, VM `192.168.10.245`, disque `DISK_FMT=qcow2`.

## Prompt de départ

```
> ok, vas y pour le deploiement du srv-dc2, essais de mettre un peu de
  graphique dedans a la fin, par exemple avec la mmc dns ou la mmc
  "utilisateurs et ordinateurs AD ..." pour montrer le conteneur
  "controleurs de domaine"
```

**Format :** 1920×1080 (16:9, YouTube standard) · 6 scènes · **3 min 29,5 s** au total · H.264 faststart
**Cible :** SRV-DC2, Windows Server 2022 (Dockur / QEMU-KVM, macvlan `192.168.10.245`)

## Les scènes

| # | Fichier | Scène | Durée | Taille |
|---|---|---|---|---|
| 1 | `dc2-scene1.mp4` | Déployer srv-dc2 avec Dockur (prise passive letterboxée) | 32,0 s | 638 Ko |
| 2 | `dc2-scene2.mp4` | Joindre le domaine et promouvoir + reboot | 56,5 s | 2,2 Mo |
| 3 | `dc2-scene3.mp4` | Vérifier la réplication et les rôles | 22,0 s | 722 Ko |
| 4 | `dc2-scene4.mp4` | MMC ADUC : le conteneur « Domain Controllers » | 30,0 s | 514 Ko |
| 5 | `dc2-scene5.mp4` | MMC DNS : la zone servie par les deux DC | 35,5 s | 644 Ko |
| 6 | `dc2-scene6.mp4` | Résilience : srv-dc coupé, le domaine répond | 33,5 s | 1,3 Mo |
| — | `dc2-chapitre-complet.mp4` | Les 6 scènes bout à bout | 3 min 29,5 s | 6,0 Mo |

## Réalisation

La scène 1 est une capture passive (une frame toutes les 3 s pendant
l'installation non pilotée, 1280×800 letterboxé dans la bande VM). Les scènes
2 à 6 : capture VNC de la console (2 fps) pilotée par la timeline JSON,
composition 16:9 via `compose_wide.py` + la spec (même gabarit que la Video-1),
encodage ffmpeg (`setpts`, 30 fps, faststart). Les identifiants de promotion
sont pré-étapés en DPAPI (`cred.xml`) et importés à l'antenne — verbatim :

```
$c = import-clixml c:\temp\cred.xml
install-addsdomaincontroller -domainname aiitops.local -credential $c `
  -safemodeadministratorpassword $c.password -installdns -force
```

Specs et timelines incluses : les prises sont rejouables à l'identique. La
première tentative de promotion a échoué sur le piège DNS/IPv6 documenté dans
`ETAT.md` (AAAA publiques via SLAAC + DHCPv6 sur macvlan) — prise écartée du
montage, leçon conservée.

## Contenu

- `dc2-chapitre-complet.mp4` — le chapitre complet
- `dc2-scene1..6.mp4` — les scènes individuelles
- `specs/` — textes et cadrage de chaque composition
- `timelines/` — les actions et leurs timings
- `README.md` — cette description
