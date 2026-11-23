#!/usr/bin/env python3
"""Execute une timeline VNC (frappe seule, sans capture)."""
import json, os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from vncdotool import api
from vm_capture import type_text

def main():
    tl = json.load(open(sys.argv[1], encoding='utf-8'))
    host = sys.argv[2] if len(sys.argv) > 2 else '127.0.0.1::5901'
    c = api.connect(host)
    c.keyDown('shift'); time.sleep(0.12); c.keyUp('shift'); time.sleep(0.3)
    c.mouseMove(900, 400); time.sleep(0.2); c.mousePress(1); time.sleep(0.15); c.mouseUp(1)
    time.sleep(0.4)
    t0 = time.time()
    for act in sorted(tl, key=lambda a: a['t']):
        w = act['t'] - (time.time() - t0)
        if w > 0:
            time.sleep(w)
        k = act.get('type')
        if k == 'cmd':
            type_text(c, act['text'], layout=act.get('layout', 'us'), delay=act.get('delay', 0.03))
            if act.get('enter'):
                time.sleep(0.25)
                c.keyPress('enter')
        elif k == 'key':
            c.keyPress(act['key'])
        elif k == 'wait':
            time.sleep(act.get('seconds', 1))
        elif k == 'click':
            c.mouseMove(act['x'], act['y']); time.sleep(0.2)
            c.mousePress(1); time.sleep(0.15); c.mouseUp(1)
    time.sleep(1.0)
    c.disconnect()
    print('timeline done in', round(time.time() - t0, 1), 's')

if __name__ == '__main__':
    main()
