#!/usr/bin/env python3
# e2e.py LOG: e2e.sh's time-runs, per unit: each round's median wall and CPU (user + system) time of each build's -c with
# --deferred-bodies (list 1) and without (list 2, source order); then over rounds, the median and range of the candidate
# against main on list 1 and of main's list 1 against its list 2.
import re, sys, statistics as st
from collections import defaultdict
runs = defaultdict(list)
unit = rnd = None
for line in open(sys.argv[1], errors="replace"):
    m = re.match(r"== round (\d+) unit (\S+)", line)
    if m: rnd, unit = int(m.group(1)), m.group(2); continue
    m = re.match(r"run \d+ list (\d) (\w+): ([\d.]+) ms wall, ([\d.]+) ms user, ([\d.]+) ms system", line)
    if m and unit:
        runs[(unit, rnd, int(m.group(1)), m.group(2))].append((float(m.group(3)), float(m.group(4)) + float(m.group(5))))
units = []
for k in runs:
    if k[0] not in units: units.append(k[0])
def ratio(a, b, i): return st.median(x[i] for x in a) / st.median(x[i] for x in b) - 1
for u in units:
    rounds = sorted({k[1] for k in runs if k[0] == u})
    cw, cc, dw, dc = [], [], [], []
    for r in rounds:
        m1, c1, m2 = runs[(u, r, 1, "main")], runs[(u, r, 1, "cand")], runs[(u, r, 2, "main")]
        cw.append(ratio(c1, m1, 0)); cc.append(ratio(c1, m1, 1)); dw.append(ratio(m1, m2, 0)); dc.append(ratio(m1, m2, 1))
    mw = st.median(st.median(x[0] for x in runs[(u, r, 1, "main")]) for r in rounds)
    mc = st.median(st.median(x[1] for x in runs[(u, r, 1, "main")]) for r in rounds)
    f = lambda v: f"{100*st.median(v):+5.1f}% [{100*min(v):+.1f},{100*max(v):+.1f}]"
    print(f"{u:24s} rounds={len(rounds)} main deferred: {mw:7.2f} ms wall {mc:7.2f} ms cpu | main deferred vs source order: wall {f(dw)} cpu {f(dc)} | cand vs main: wall {f(cw)} cpu {f(cc)}")
