#!/usr/bin/env python3
"""Compose une video 16:9 (1920x1080, format YouTube standard) depuis des frames VNC.

Usage :
    python compose_wide.py <spec.json> <frames_dir> <out_dir>

Trois bandes empilees :
    - panneau prompt  (titre + question + puces + commande)   prompt_h
    - bande VM        (capture de l'ecran recadree)           vm_h
    - panneau resultat (coches + prochaine etape)             result_h
Le spec JSON decide des hauteurs via "layout" et du cadrage via "crop".
"""
import glob
import json
import os
import sys

from PIL import Image, ImageDraw, ImageFont

W, H = 1920, 1080
BG = "#0d1117"
FG = "#e6edf3"
ACC = "#58a6ff"
GRN = "#3fb950"
DIM = "#8b949e"
PANEL = "#161b22"
BAND_BG = "#000000"
FONTS = os.environ.get("PANEL_FONTS", "/home/hermes/.hermes/cache/scratch/fonts")


def font(size, bold=False):
    name = "DejaVuSansMono-Bold.ttf" if bold else "DejaVuSansMono.ttf"
    try:
        return ImageFont.truetype(os.path.join(FONTS, name), size)
    except Exception:
        return ImageFont.load_default()


def make_prompt(spec, height):
    img = Image.new("RGB", (W, height), BG)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, 56], fill=PANEL)
    d.text((40, 12), spec.get("title", "hermes"), font=font(30, True), fill=ACC)
    d.ellipse([W - 56, 20, W - 36, 40], fill=GRN)
    # Pied de page ramene dans la barre de titre : il ne peut plus chevaucher
    # les blocs de la bande resultat, qui est basse en 16:9.
    foot = spec.get("footer", [])
    if foot:
        d.text((W - 560, 20), "  \u00b7  ".join(foot), font=font(20), fill="#484f58")

    y = 72
    for line in spec.get("prompt", []):
        d.text((48, y), line, font=font(32), fill=FG)
        y += 42
    y += 8
    for b in spec.get("bullets", []):
        d.text((48, y), "\u00b7 " + b, font=font(26), fill=DIM)
        y += 34
    y += 12
    cmd = spec.get("command")
    if cmd:
        d.text((48, y), cmd, font=font(28, True), fill=GRN)

    rule = spec.get("prompt_rule", "none")
    if rule == "accent":
        d.rectangle([0, height - 4, W, height], fill=ACC)
    elif rule == "subtle":
        d.rectangle([0, height - 2, W, height], fill="#21262d")
    return img


def make_result(spec, height):
    img = Image.new("RGB", (W, height), BG)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, 4], fill=ACC)
    y = 14
    items = spec.get("results", [])
    if items:
        d.text((48, y), spec.get("result_label", "R\u00c9SULTAT"), font=font(22, True), fill=DIM)
        y += 32
        for item in items:
            d.text((48, y), "\u2713  " + item, font=font(28), fill=GRN)
            y += 38

    nxt = spec.get("next")
    if nxt:
        d.rectangle([48, y + 4, W - 48, y + 6], fill="#21262d")
        y += 14
        d.text((48, y), spec.get("next_label", "PROCHAINE \u00c9TAPE"), font=font(20, True), fill=DIM)
        y += 26
        for line in nxt:
            d.text((48, y), line, font=font(26), fill=FG)
            y += 30

    concl = spec.get("conclusion")
    if concl:
        d.rectangle([48, y + 4, W - 48, y + 6], fill="#21262d")
        y += 16
        d.text((48, y), spec.get("conclusion_label", "EN R\u00c9SUM\u00c9"), font=font(22, True), fill=DIM)
        y += 30
        for line in concl:
            d.text((48, y), line, font=font(28), fill=FG)
            y += 34

    # Le pied de page est dessine dans la barre de titre du panneau prompt
    # (make_prompt) : la bande resultat reste reservee aux resultats.
    return img


def fit_band(img, crop, band_h, band_bg=BAND_BG):
    """Recadre sur la zone utile, ajuste par la largeur, centre sur fond band_bg."""
    c = img.crop(tuple(crop))
    w, h = c.size
    nh = int(h * W / w)
    band = Image.new("RGB", (W, band_h), band_bg)
    if nh <= band_h:
        resized = c.resize((W, nh), Image.LANCZOS)
        band.paste(resized, (0, (band_h - nh) // 2))
        return band
    # trop haut : ajuster par la largeur puis rogner en BAS uniquement.
    # Ne jamais rogner les cotes : le prompt "PS C:\..." et la fin des lignes
    # longues seraient tronques (artefact constate sur les 3 scenes AD).
    resized = c.resize((W, max(1, int(round(h * W / w)))), Image.LANCZOS)
    band.paste(resized.crop((0, 0, W, band_h)), (0, 0))
    return band


def main():
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(1)
    spec = json.load(open(sys.argv[1], encoding="utf-8"))
    src, out = sys.argv[2], sys.argv[3]

    layout = spec.get("layout", {})
    prompt_h = layout.get("prompt_h", 300)
    vm_h = layout.get("vm_h", 620)
    result_h = H - prompt_h - vm_h

    os.makedirs(out, exist_ok=True)
    for f in glob.glob(os.path.join(out, "*.png")):
        os.remove(f)

    canvas = Image.new("RGB", (W, H), BG)
    canvas.paste(make_prompt(spec, prompt_h), (0, 0))
    canvas.paste(make_result(spec, result_h), (0, prompt_h + vm_h))

    files = sorted(glob.glob(os.path.join(src, "f_*.png")))
    # max_frames : coupe la fin morte de la capture (curseur qui clignote = jamais
    # "stable" pour idle_wait, donc la prise va jusqu'au timeout). 0 = tout garder.
    max_frames = int(spec.get("max_frames", 0))
    if max_frames:
        files = files[:max_frames]
    crop = spec.get("crop", [0, 0, 1920, 1080])
    band_bg = spec.get("band_bg", BAND_BG)
    max_hold = int(spec.get("max_hold", 0))
    n = 0
    last_sig = None
    hold = 0
    for fp in files:
        img = Image.open(fp).convert("RGB")
        if max_hold:
            sig = img.resize((64, 48)).tobytes()
            if sig == last_sig:
                hold += 1
                if hold > max_hold:
                    continue
            else:
                last_sig = sig
                hold = 0
        band = fit_band(img, crop, vm_h, band_bg)
        c = canvas.copy()
        c.paste(band, (0, prompt_h))
        n += 1
        c.save(os.path.join(out, f"f_{n:04d}.png"))

    extra_img = spec.get("hold_image")
    if extra_img and os.path.exists(extra_img):
        band = fit_band(Image.open(extra_img).convert("RGB"), crop, vm_h, band_bg)
        c = canvas.copy()
        c.paste(band, (0, prompt_h))
        for _ in range(spec.get("hold_frames", 12)):
            n += 1
            c.save(os.path.join(out, f"f_{n:04d}.png"))

    print(f"{n} frames composees -> {out}/")


if __name__ == "__main__":
    main()
