#!/usr/bin/env python3
# #1629: from rounds4's logs, each tree's floor (each file's least per-run minimum over the rounds) of the object stage
# as run (cold) and of its warm second run stopped after its Nth call (1 link_check, 2 object_prepare, 3
# object_map_symbols, 4 object_build), and each call's share (N minus N-1), per file in ns, for c-testsuite's programs
# under 300 tokens and from 3,000, and each synthetic unit; also the publication (cold runs only).
# Usage: warm_calls.py LOGS_DIR TREE...
import sys, glob, re, collections
d, trees = sys.argv[1], sys.argv[2:]
fl = collections.defaultdict(dict); tok = {}
for p in glob.glob(f'{d}/*-round-*-*.txt'):
    m = re.search(r'/(c-testsuite|synthetic)-(cold|\d)-round-\d+-(\w+)\.txt$', p); kind, w, t = m.groups()
    for line in open(p):
        if 'file=' in line and ' ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:]); n = f['file'].rsplit('/', 1)[-1]; tok[n] = int(f['tokens'])
            for k in ('min_object', 'min_publish'):
                key = (kind, w, t, k); v = float(f[k]); fl[key][n] = min(v, fl[key].get(n, 1e18))
def avg(kind, w, t, k, sel):
    vals = [fl[(kind, w, t, k)][n] for n in sel if n in fl[(kind, w, t, k)]]
    return sum(vals) / len(vals) if vals else float('nan')
names = sorted(tok)
groups = [('c-testsuite', 'under 300 tokens', [n for n in names if n.endswith('.c') and n[0].isdigit() and tok[n] < 300]),
          ('c-testsuite', '3,000 tokens or more', [n for n in names if n[0].isdigit() and tok[n] >= 3000])]
groups += [('synthetic', n, [n]) for n in names if not n[0].isdigit()]
calls = ['link_check', 'object_prepare', 'object_map_symbols', 'object_build']
for kind, label, sel in groups:
    print(f'== {kind}: {label} ({len(sel)} files), ns per file')
    for t in trees:
        cold = avg(kind, 'cold', t, 'min_object', sel); pub = avg(kind, 'cold', t, 'min_publish', sel)
        cum = [avg(kind, str(n), t, 'min_object', sel) for n in (1, 2, 3, 4)]
        parts = [cum[0]] + [cum[i] - cum[i - 1] for i in (1, 2, 3)]
        print(f'  {t:9s} publication {pub:10.1f}  object {cold:10.1f}  warm {cum[3]:10.1f}  ' + '  '.join(f'{c} {p:9.1f}' for c, p in zip(calls, parts)))
