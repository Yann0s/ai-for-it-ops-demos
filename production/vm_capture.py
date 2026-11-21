#!/usr/bin/env python3
"""Capture VNC pilotée : helpers de frappe (AZERTY / US) + prise planifiée.

Usage :
    python vm_capture.py <sortie_frames> <duree_s> <timeline.json>

Exemple de timeline.json :
    [
      {"t": 2.0,  "type": "cmd", "text": "hostname"},
      {"t": 3.0,  "type": "key", "key": "enter"},
      {"t": 6.0,  "type": "cmd", "text": "ping microsoft.com -n 2"},
      {"t": 7.0,  "type": "key", "key": "enter"}
    ]
"""
import json
import os
import sys
import time

from vncdotool import api

HOST = os.environ.get("VNC_HOST", "localhost::5902")

# QEMU traduit le keysym envoye en scancodes via un keymap US (les modificateurs
# envoyes par le client sont ignores). Donc : pour une VM US, envoyer le keysym du
# caractere ; pour une VM AZERTY, envoyer le keysym US de la touche physique.
_LETTERS = {
    "a": "q", "b": "b", "c": "c", "d": "d", "e": "e", "f": "f", "g": "g",
    "h": "h", "i": "i", "j": "j", "k": "k", "l": "l", "m": ";", "n": "n",
    "o": "o", "p": "p", "q": "a", "r": "r", "s": "s", "t": "t", "u": "u",
    "v": "v", "w": "z", "x": "x", "y": "y", "z": "w",
}
_PUNCT = {
    "-": "6", ".": "<", ",": "m", ";": ",", ":": ".", "/": ">", "!": "/",
    "?": "M", "(": "5", ")": "-", "=": "=", "+": "+", "_": "8", '"': "3",
    "'": "4", "$": "]", "^": "[", "*": '"', "\u00f9": "'", "&": "1",
    "\u00e9": "2", "\u00e8": "7", "\u00e7": "9", "\u00e0": "0",
}
AZERTY_TO_US = dict(_LETTERS)
AZERTY_TO_US.update({k.upper(): v.upper() for k, v in _LETTERS.items()})
AZERTY_TO_US.update(_PUNCT)
# non typables en AZERTY sans AltGr : ~ @ # \ |

# En layout US : ces caracteres necessitent un Shift reel (envoye avec un delai,
# sinon QEMU perd le modificateur). Les majuscules, elles, passent en envoyant
# directement le keysym majuscule.
US_SHIFT = {
    "~": "`", "!": "1", "@": "2", "#": "3", "$": "4", "%": "5", "^": "6",
    "&": "7", "*": "8", "(": "9", ")": "0", "_": "-", "+": "=", "{": "[",
    "}": "]", "|": "\\", ":": ";", '"': "'", "<": ",", ">": ".", "?": "/",
}


def type_text(c, text, layout="us", delay=0.03):
    """Tape un texte. layout='us' (VM QWERTY) ou 'azerty' (VM FR)."""
    for ch in text:
        if ch == " ":
            c.keyPress("space")
        elif layout == "azerty":
            ks = AZERTY_TO_US.get(ch)
            if ks is None:
                raise ValueError(f"caractere non typable en AZERTY: {ch!r}")
            c.keyPress(ks)
        elif ch in US_SHIFT:
            c.keyDown("shift")
            time.sleep(0.09)
            c.keyPress(US_SHIFT[ch])
            time.sleep(0.05)
            c.keyUp("shift")
            time.sleep(0.07)
        else:
            c.keyPress(ch)
        time.sleep(delay)


def run_take(out_dir, duration, timeline, host=HOST, fps_sleep=0.15):
    """Capture en continu et execute la timeline (secondes, une fois chaque)."""
    os.makedirs(out_dir, exist_ok=True)
    c = api.connect(host)
    pending = sorted(timeline, key=lambda a: a["t"])
    start = time.time()
    i = 0
    total = 0

    while True:
        t = time.time() - start
        i += 1
        c.captureScreen(os.path.join(out_dir, f"f_{i:03d}.png"))
        total += 1
        while pending and pending[0]["t"] <= t:
            act = pending.pop(0)
            kind = act.get("type")
            if kind == "cmd":
                type_text(c, act["text"], layout=act.get("layout", "us"))
            elif kind == "key":
                c.keyPress(act["key"])
            elif kind == "click":
                c.mouseMove(act["x"], act["y"])
                time.sleep(0.2)
                c.mousePress(1)
                time.sleep(0.15)
                c.mouseUp(1)
            elif kind == "wait":
                time.sleep(act.get("seconds", 1))
        if t > duration:
            break
        time.sleep(fps_sleep)

    c.disconnect()
    print(f"{total} frames dans {out_dir} ({t:.0f}s)")
    return total


if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(1)
    with open(sys.argv[3], encoding="utf-8") as fh:
        tl = json.load(fh)
    run_take(sys.argv[1], float(sys.argv[2]), tl)
