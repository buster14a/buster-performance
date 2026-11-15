#!/usr/bin/env python3
# grid3.py: candidate costs n + B*blocks + n^2/K + F (optnone n/D + F), scored on each data set by the plan's longest part,
# a part's time being its functions' measured code-generation times plus the rest each part's compile showed: a fixed
# part and an amount per definition, fit per data set from the traces (parts.py's "rest").
import json, os, re, subprocess, sys
import numpy as np
PLAN = os.path.expanduser('~/.cache/claude-2639/tools/plan')
def load(align_path, feat_path, traces):
    order = [l.rstrip('\n').split('\t') for l in open(align_path)]
    A, S, names = [], [], []
    for c in order:
        A.append(max(int(c[1]), 1 if (int(c[2]) or int(c[3])) else 16)); S.append(1 if c[5] != '-' else (2 if int(c[4]) else 0)); names.append(c[7])
    feats = {}
    for l in open(feat_path):
        c = l.rstrip('\n').split('\t'); feats[c[2]] = [int(v) for v in c[3:]]
    times = {}; rest = []
    part_defs = {}
    for c in (l.rstrip('\n').split('\t') for l in open(feat_path)):
        part_defs[int(c[0])] = part_defs.get(int(c[0]), 0) + 1
    for path in traces:
        p = int(re.search(r'part(\d+)\.json$', path).group(1))
        ev = json.load(open(path))['traceEvents']
        fn = 0
        for e in ev:
            if e.get('ph') == 'X' and e.get('name') == 'OptFunction':
                times[e['args']['detail']] = times.get(e['args']['detail'], 0) + e['dur']; fn += e['dur']
        wall = max(e['dur'] for e in ev if e.get('name') == 'ExecuteCompiler')
        rest.append((part_defs[p], (wall - fn) / 1e6))
    keep = [i for i, n in enumerate(names) if n in feats]
    X = np.array([feats[names[i]] for i in keep], dtype=float)
    y = np.array([times.get(names[i], 0) for i in keep], dtype=float) / 1e6
    A = np.array([A[i] for i in keep]); S = np.array([S[i] for i in keep])
    r = np.array(rest); c1, c0 = np.polyfit(r[:, 0], r[:, 1], 1)
    return dict(X=X, y=y, A=A, S=S, c0=c0, c1=c1)
def plan(cost, A, S, rule):
    data = '\n'.join(f'{c} {A[i]} {S[i]}' for i, c in enumerate(cost))
    out = subprocess.run([PLAN, '8', '1' if rule else '0'], input=data, capture_output=True, text=True, check=True).stdout
    st = [int(v) for v in out.split()]; return list(zip(st, st[1:] + [len(cost)]))
def longest(ds, pred, rule):
    cost = [max(1, int(round(v))) for v in pred]
    b = plan(cost, ds['A'], ds['S'], rule)
    parts = [ds['y'][i:j].sum() + ds['c0'] + ds['c1'] * (j - i) for i, j in b]
    return max(parts), sum(parts) / 8
def model(ds, B, K, F, D):
    X = ds['X']; n, blk, on = X[:, 0], X[:, 1], X[:, 10] > 0
    return np.where(on, (n + D - 1) // D, n + B * blk + n * n / K) + F
sets = {}
for name, d in [] + [(a, b) for a, b in (x.split('=') for x in sys.argv[1:])]:
    if name == 'memory-local':
        ds = load(f'{d}/align-memory.tsv', f'{d}/trace-memory/features.tsv', sorted(__import__('glob').glob(f'{d}/trace-memory/part*.json')))
    else:
        ds = load(f'{d}/align.tsv', f'{d}/features.tsv', sorted(__import__('glob').glob(f'{d}/part*.json')))
    sets[name] = ds
    print(f'{name}: rest per part {ds["c0"]:.2f} s + {1000*ds["c1"]:.2f} ms a definition; functions {ds["y"].sum():.1f} s')
shares = {}
for name, ds in sets.items():
    cur = np.where(ds['X'][:, 10] > 0, (ds['X'][:, 0] + 3) // 4, ds['X'][:, 0]) + 8
    m, even = longest(ds, cur, False)
    shares[name] = even
    print(f'padded {name}: instruction count {m:.1f} s, even share {even:.1f} s')
rows = []
for B, K, F, D in [(2, 50000, 30, 4)] + [(B, K, F, D) for B in (0, 2) for K in (35000, 50000, 75000, 100000) for F in (30, 60, 100, 150) for D in (4, 6, 8)]:
    res = [longest(ds, model(ds, B, K, F, D), False)[0] for ds in sets.values()]
    rows.append((sum(r / shares[n] for r, n in zip(res, sets)), res, B, K, F, D))
print('score B K F D: ' + ' | '.join(sets))
for score, res, B, K, F, D in [rows[0]] + sorted(rows[1:])[:12]:
    print(f'{score:.3f} {B} {K} {F} {D}: ' + ' | '.join(f'{v:6.1f}' for v in res))
