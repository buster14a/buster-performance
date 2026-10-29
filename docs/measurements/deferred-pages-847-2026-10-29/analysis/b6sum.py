#!/usr/bin/env python3
# Campaign B6 (#847): each unit's medians over the rounds of the eight-lane reading (by the rule, or with every lane) of
# the tree as it is, forced huge (no unit large) and forced base (every unit large), and main by its rule; their changes
# against main; the every-lane walks' spread; and for each threshold T of the unit's tokens, the reading of a tree that
# takes `huge` below T and `base` from T on, against the faster of main and `base` (#791's policy).
#   b6sum.py LOG TREE MAIN
import collections, re, statistics, sys
log, tree, main = sys.argv[1:4]
fieldre = re.compile(r'(\w+)=([-\w./]+)')
runs = collections.defaultdict(list)
tokens = {}
cur = None
for line in open(log, errors='replace'):
    if line.startswith('== round '):
        p = line.split()
        cur = dict(round=int(p[2]), name=p[3], unit=p[4], readings={})
        runs[(p[3], p[4])].append(cur)
    elif cur is not None and line.startswith('checker-deferred: file='):
        f = dict(fieldre.findall(line))
        tokens[cur['unit']] = int(f['tokens'])
        cur['large'] = f.get('large')
    elif cur is not None and line.startswith('checker-deferred:   lanes=') and 'active=' in line:
        f = dict(fieldre.findall(line))
        cur['readings'][int(f['lanes'])] = {k: float(v) for k, v in f.items() if re.match(r'^-?[\d.]+$', v)}
    elif cur is not None and line.startswith('exit='):
        cur['exit'] = line.split()[0]
def med(name, unit, lanes, field):
    values = [r['readings'][lanes][field] for r in runs[(name, unit)] if lanes in r['readings']]
    return statistics.median(values) if values else None
def walks(name, unit):
    values = [r['readings'][8]['walks'] for r in runs[(name, unit)] if 8 in r['readings']]
    return values
units = sorted({u for (_, u) in runs}, key=lambda u: tokens.get(u, 0))
names = [tree, tree + '-huge', tree + '-base', main]
print('| Unit | Tokens | Lanes: as is, huge, base, main | As is | Huge | Base | Main | As is against main | Huge against main | Base against main | Every-lane walks spread: huge, base |')
print('| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |')
rows = []
for u in units:
    whole = [med(n, u, 8, 'whole') for n in names]
    lanes = [med(n, u, 8, 'active') for n in names]
    if None in whole:
        continue
    spreads = []
    for n in (tree + '-every-huge', tree + '-every-base'):
        w = walks(n, u)
        spreads.append(max(w) - min(w) if w else float('nan'))
    rows.append((u, tokens[u], whole, lanes, spreads))
    ch = [100 * (w / whole[3] - 1) for w in whole[:3]]
    print(f'| `{u}.c` | {tokens[u]} | {"/".join(str(int(l)) for l in lanes)} | {whole[0]:.2f} | {whole[1]:.2f} | {whole[2]:.2f} | {whole[3]:.2f} | '
          f'{ch[0]:+.1f}% | {ch[1]:+.1f}% | {ch[2]:+.1f}% | {spreads[0]:.1f}, {spreads[1]:.1f} |')
def summary(index, label):
    ch = [100 * (r[2][index] / r[2][3] - 1) for r in rows]
    print(f'{label} against main: median {statistics.median(ch):+.2f}% ({min(ch):+.1f} to {max(ch):+.1f}), over +2%: {sum(c > 2 for c in ch)}')
print()
summary(0, 'as is')
summary(1, 'huge')
summary(2, 'base')
ch = [100 * (r[2][0] / r[2][2] - 1) for r in rows]
print(f'as is against base: median {statistics.median(ch):+.2f}% ({min(ch):+.1f} to {max(ch):+.1f}), over +2%: {sum(c > 2 for c in ch)}')
for k, label in ((0, 'huge'), (1, 'base')):
    s = [r[4][k] for r in rows]
    print(f'every-lane walks spread, {label}: median {statistics.median(s):.2f}, highest {max(s):.2f} ({rows[s.index(max(s))][0]})')
print()
print('threshold T: the tokens from which a unit is large; each unit huge below T, base from T on, against the faster of main and base')
candidates = sorted({r[1] for r in rows} | {48640})
for t in candidates:
    worst = []
    for u, n, whole, lanes, spreads in rows:
        composite = whole[1] if n < t else whole[2]
        best = min(whole[2], whole[3])
        worst.append(100 * (composite / best - 1))
    print(f'  T={t:7d}: median {statistics.median(worst):+.2f}%, worst {max(worst):+.2f}%, over +2%: {sum(w > 2 for w in worst)}')
