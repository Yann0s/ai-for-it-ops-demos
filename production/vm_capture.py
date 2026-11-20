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

# touches US a envoyer pour obtenir le caractere AZERTY voulu
AZERTY_MAP = {"a": "q", "m": ";", "z": "w", "w": "z", "-": "6", "'": "4", "=": "8"}

# caracteres US necessitant Shift (keysym de base -> keysym envoye)
US_SHIFT = {
    "~": "`", "!": "1", "@": "2", "#": "3", "$": "4", "%": "5", "^": "6",
    "&": "7", "*": "8", "(": "9", ")": "0", "_": "-", "+": "=", "{": "[",
    "}": "]", "|": "\\", ":": ";", '"': "'", "<": ",", ">": ".", "?": "/",
}


def type_text(c, text, layout="us", delay=0.03):
    """Tape un texte. layout='us' (VM en QWERTY) ou 'azerty' (VM en FR)."""
    for ch in text:
        if ch == " ":
            c.keyPress("space")
        elif layout == "azerty":
            if ch.isupper():
                base = AZERTY_MAP.get(ch.lower(), ch.lower())
                c.keyDown("shift")
                c.keyPress(base)
                c.keyUp("shift")
            elif ch.isdigit():
                c.keyDown("shift")
                c.keyPress(ch)
                c.keyUp("shift")
            else:
                c.keyPress(AZERTY_MAP.get(ch, ch))
        else:  # us
            if ch in US_SHIFT:
                c.keyDown("shift")
                c.keyPress(US_SHIFT[ch])
                c.keyUp("shift")
            elif ch.isupper():
                c.keyDown("shift")
                c.keyPress(ch.lower())
                c.keyUp("shift")
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
