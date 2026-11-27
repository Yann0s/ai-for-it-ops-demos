#!/usr/bin/env python3
"""Assemble deux prises VNC en une seule séquence de frames.

Une scène qui traverse un redémarrage se filme en deux prises (une VM éteinte
ne répond plus au VNC). Ce script recolle les deux en contenant le démarrage :
il garde la tête de la prise A, maintient la frame de commande quelques
instants (l'action suivante démarre souvent moins d'une seconde après), puis
n'échantillonne qu'une frame sur N pendant le démarrage.

Usage :
    python compose_takes.py --a /tmp/f4a --b /tmp/f4b --out /tmp/f4seq \
        [--hold 10] [--boot-every 10] [--head 14] [--b-max 46]

Les frames de sortie sont nommées f_0001.png, f_0002.png… prêtes pour
compose_wide.py / make_video.sh.
"""
import argparse
import glob
import os
import shutil


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--a", required=True, help="frames avant le redémarrage")
    ap.add_argument("--b", required=True, help="frames après le redémarrage")
    ap.add_argument("--out", required=True)
    ap.add_argument("--head", type=int, default=14,
                    help="frames de A gardées avant le maintien")
    ap.add_argument("--hold", type=int, default=10,
                    help="duplicatas de la frame de commande")
    ap.add_argument("--boot-every", type=int, default=10,
                    help="une frame sur N pendant le démarrage")
    ap.add_argument("--b-max", type=int, default=46,
                    help="frames utiles de B (coupe la queue inactive)")
    ap.add_argument("--b-hold", type=int, default=8,
                    help="duplicatas de la dernière frame de B")
    args = ap.parse_args()

    a = sorted(glob.glob(os.path.join(args.a, "f_*.png")))
    b = sorted(glob.glob(os.path.join(args.b, "f_*.png")))
    if not a or not b:
        raise SystemExit("frames manquantes dans --a ou --b")
    print(f"prise A {len(a)} frames, prise B {len(b)}")

    if os.path.isdir(args.out):
        shutil.rmtree(args.out)
    os.makedirs(args.out)

    head = a[:args.head]
    command_frame = head[-1]
    boot = a[args.head:]
    sampled = [fp for i, fp in enumerate(boot) if i % args.boot_every == 0]
    tail = boot[-4:]
    keep = set(sampled) | set(tail)

    b_cut = b[:args.b_max]

    out = list(head) + [command_frame] * args.hold
    out += [fp for fp in boot if fp in keep]
    out += b_cut + [b_cut[-1]] * args.b_hold

    for n, fp in enumerate(out, 1):
        shutil.copyfile(fp, os.path.join(args.out, f"f_{n:04d}.png"))

    print(f"{len(out)} frames -> {args.out} "
          f"(maintien {args.hold}, démarrage {len(keep)}, queue B {args.b_hold})")


if __name__ == "__main__":
    main()
