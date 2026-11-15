#!/usr/bin/env python3
# parts.py DIR: each part's compile (ExecuteCompiler), the code generator's per-function time (OptFunction) and the rest,
# with its definitions and instructions (features.tsv), from DIR's part*.json traces.
import json, sys, os
d = sys.argv[1]
feat = {}
for l in open(os.path.join(d, 'features.tsv')):
    c = l.rstrip('\n').split('\t')
    feat.setdefault(int(c[0]), []).append((int(c[3]), int(c[4]), int(c[13])))
for p in range(8):
    ev = json.load(open(os.path.join(d, f'part{p}.json')))['traceEvents']
    wall = max(e['dur'] for e in ev if e.get('name') == 'ExecuteCompiler') / 1e6
    fn = sum(e['dur'] for e in ev if e.get('ph') == 'X' and e.get('name') == 'OptFunction') / 1e6
    f = feat[p]
    ins = sum(x[0] for x in f if not x[2]); opt = sum(x[0] for x in f if x[2]); n = len(f); nopt = sum(1 for x in f if x[2])
    print(f'part {p}: compile {wall:5.1f} s, functions {fn:5.1f} s, rest {wall-fn:4.1f} s; {n:5d} definitions ({nopt:4d} optnone), {ins:8d} instructions, {opt:8d} optnone')
