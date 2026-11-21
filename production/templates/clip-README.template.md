# Clip {{ID}} — {{TITRE}}

## Stack

- **Hermes Desktop** (Mac) — poste de pilotage : on lance la prise et on suit l'exécution.
- **Hermes Agent** (VPS) — orchestre la scène : tunnel SSH vers le serveur Linux local, pilote la console VNC, capture les frames et compose le clip.
- **Dockur** (serveur Linux local, ubu1) — les maquettes : conteneurs QEMU/KVM avec IP macvlan sur le LAN ({{MAQUETTES}}).

## Prompt de départ

```
{{PROMPT}}
```

**Format :** {{LARGEUR}}×{{HAUTEUR}} ({{RATIO}}) · {{DUREE}} s · {{CODEC}} · {{TAILLE}}
**Cible :** {{CIBLE}}, {{OS}} (Dockur / QEMU-KVM, macvlan `{{IP}}`)

## Ce que montre le clip

| Étape | Commande | Résultat |
|---|---|---|
{{LIGNES_TABLEAU}}

## Réalisation

Capture VNC de la console ({{FPS}} fps) pilotée par `{{TIMELINE}}`, composition 9:16 via `compose_short.py` + `{{SPEC}}`, encodage ffmpeg (`setpts={{SPEED}}*PTS`, 30 fps). Timeline et spec sont incluses : la prise est rejouable à l'identique.

## Contenu

- `{{VIDEO}}` — le clip
- `{{TIMELINE}}` — les actions et leurs timings
- `{{SPEC}}` — textes et cadrage de la composition
- `README.md` — cette description

<!--
Gabarit des README de clip (voir Clip-0.1/README.md comme exemple validé).

Règles :
- Un dossier par clip : Clip-<ID>/ à la racine du dépôt (Clip-0.1, Clip-0.2, ...).
- Toujours les 4 fichiers : le MP4, la timeline, la spec, ce README.
- La section « Stack » décrit les briques réelles, pas la théorie.
- Le « Prompt de départ » est le texte exact affiché dans le panneau haut du clip.
- Le tableau reprend une ligne par étape visible à l'écran (commande → résultat).
- Ne pas inventer de chiffres : durée, taille et format viennent de ffprobe.
-->
