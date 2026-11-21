#!/usr/bin/env python3
"""Compose un short 9:16 depuis des frames VNC + un panneau prompt et un panneau resultat.

Usage :
    python compose_short.py <spec.json> <frames_dir> <out_dir>

Le spec JSON décrit les textes et le cadrage (voir production/specs/cli01-ssh.json).
"""
import glob
import json
import os
import sys

from PIL import Image, ImageDraw, ImageFont

W, H = 1080, 1920
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
    d.text((26, 15), spec.get("title", "hermes"), font=font(24, True), fill=ACC)
    d.ellipse([W - 40, 22, W - 26, 36], fill=GRN)

    y = 80
    for line in spec.get("prompt", []):
        d.text((34, y), line, font=font(30), fill=FG)
        y += 44
    y += 22
    for b in spec.get("bullets", []):
        d.text((34, y), "\u00b7 " + b, font=font(26), fill=DIM)
        y += 40
    y += 24
    cmd = spec.get("command")
    if cmd:
        d.text((34, y), cmd, font=font(26, True), fill=GRN)

    d.rectangle([34, height - 28, W - 34, height - 18], fill="#21262d")
    d.rectangle([34, height - 28, 34 + int((W - 68) * 0.86), height - 18], fill=ACC)
    return img


def make_result(spec, height):
    img = Image.new("RGB", (W, height), BG)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, 4], fill=ACC)
    y = 32
    d.text((34, y), spec.get("result_label", "R\u00c9SULTAT"), font=font(22, True), fill=DIM)
    y += 46
    for item in spec.get("results", []):
        d.text((34, y), "\u2713  " + item, font=font(27), fill=GRN)
        y += 58

    nxt = spec.get("next")
    if nxt:
        y += 18
        d.rectangle([34, y, W - 34, y + 2], fill="#21262d")
        y += 30
        d.text((34, y), spec.get("next_label", "PROCHAINE \u00c9TAPE"), font=font(20, True), fill=DIM)
        y += 34
        for line in nxt:
            d.text((34, y), line, font=font(25), fill=FG)
            y += 34

    footer = spec.get("footer", [])
    if footer:
        fy = height - 84
        d.rectangle([34, fy - 26, W - 34, fy - 24], fill="#21262d")
        d.text((34, fy), footer[0], font=font(22), fill=DIM)
        if len(footer) > 1:
            d.text((34, fy + 30), footer[1], font=font(20), fill="#484f58")
    return img


def fit_band(img, crop, band_h):
    """Recadre sur la zone utile, ajuste par la largeur, centre sur fond noir."""
    c = img.crop(tuple(crop))
    w, h = c.size
    nh = int(h * W / w)
    band = Image.new("RGB", (W, band_h), BAND_BG)
    if nh <= band_h:
        resized = c.resize((W, nh), Image.LANCZOS)
        band.paste(resized, (0, (band_h - nh) // 2))
        return band
    # trop haut : ajuster par la hauteur et rogner les cotes
    nw = int(w * band_h / h)
    left = (w - nw) // 2
    c = c.crop((left, 0, left + nw, h))
    resized = c.resize((W, band_h), Image.LANCZOS)
    band.paste(resized, (0, 0))
    return band


def main():
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(1)
    spec = json.load(open(sys.argv[1], encoding="utf-8"))
    src, out = sys.argv[2], sys.argv[3]

    layout = spec.get("layout", {})
    prompt_h = layout.get("prompt_h", 400)
    vm_h = layout.get("vm_h", 880)
    result_h = H - prompt_h - vm_h

    os.makedirs(out, exist_ok=True)
    for f in glob.glob(os.path.join(out, "*.png")):
        os.remove(f)

    canvas = Image.new("RGB", (W, H), BG)
    canvas.paste(make_prompt(spec, prompt_h), (0, 0))
    canvas.paste(make_result(spec, result_h), (0, prompt_h + vm_h))

    files = sorted(glob.glob(os.path.join(src, "f_*.png")))
    crop = spec.get("crop", [82, 218, 975, 688])
    max_hold = int(spec.get("max_hold", 0))  # 0 = pas de dedupe
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
        band = fit_band(img, crop, vm_h)
        c = canvas.copy()
        c.paste(band, (0, prompt_h))
        n += 1
        c.save(os.path.join(out, f"f_{n:04d}.png"))

    extra_img = spec.get("hold_image")
    if extra_img and os.path.exists(extra_img):
        band = fit_band(Image.open(extra_img).convert("RGB"), crop, vm_h)
        c = canvas.copy()
        c.paste(band, (0, prompt_h))
        for _ in range(spec.get("hold_frames", 12)):
            n += 1
            c.save(os.path.join(out, f"f_{n:04d}.png"))

    print(f"{n} frames composees -> {out}/")


if __name__ == "__main__":
    main()
