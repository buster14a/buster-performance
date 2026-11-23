#!/usr/bin/env python3
# survey.py LOG...: per unit and configuration, each process's medians of its passes (source order, deferred on one lane,
# deferred on the configuration's lanes) and the paired ratios; then the medians over processes and their range.
import re, sys, statistics as st
from collections import defaultdict
procs = defaultdict(list)
info = {}
for path in sys.argv[1:]:
    unit = config = None
    rows = []
    head = None
    for line in open(path, errors='replace'):
        m = re.match(r'== round (\d+) unit (\S+) config (\S+)', line)
        if m:
            unit, config = m.group(2), m.group(3); rows = []; head = None; continue
        m = re.search(r'file=\S+ tokens=(\d+) bodies=(\d+) body_tokens=(\d+) largest_body=(\d+) second_body=(\d+) top_tokens=(\d+) lane_tokens=(\d+).*merged=(\S+)', line)
        if m:
            head = m.groups(); info[unit] = head; continue
        m = re.search(r'lanes=(\d+) active=(\d+) copies', line)
        if m and head:
            active = int(m.group(2))
        m = re.search(r'pass=\d+ order=\S+ parse=\d+ source_order=(\d+) deferred_1=(\d+) deferred_\d+=(\d+) ns active=(\d+)', line)
        if m:
            rows.append(tuple(int(x) for x in m.groups())); continue
        if line.startswith('exit=') and unit:
            if rows:
                procs[(unit, config)].append(rows)
            unit = None
def med(x): return st.median(x)
out = []
for (unit, config), plist in sorted(procs.items()):
    s1 = []; sn = []; n1 = []; act = []; src = []
    for rows in plist:
        src.append(med([r[0] for r in rows]))
        s1.append(med([r[1] / r[0] for r in rows]))
        sn.append(med([r[2] / r[0] for r in rows]))
        n1.append(med([r[2] / r[1] for r in rows]))
        act.append(med([r[3] for r in rows]))
    h = info.get(unit)
    tok, bodies, bt, lg, sc, top, lt, merged = h
    tok, bt, lg, sc = int(tok), int(bt), int(lg), int(sc)
    path = max(lg, 2 * sc); excess = max(bt - path, 0)
    print(f"{unit:36s} {config:8s} n={len(plist)} tok={tok} ex/tok={excess/tok:.3f} src={med(src)/1e3:9.1f}us active={med(act):.0f} "
          f"d1/src={100*(med(s1)-1):+6.1f}% dn/src={100*(med(sn)-1):+6.1f}% [{100*(min(sn)-1):+.1f},{100*(max(sn)-1):+.1f}] "
          f"dn/d1={100*(med(n1)-1):+6.1f}% [{100*(min(n1)-1):+.1f},{100*(max(n1)-1):+.1f}] merged={merged}")
