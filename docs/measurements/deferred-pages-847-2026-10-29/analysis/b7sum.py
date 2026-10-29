#!/usr/bin/env python3
# Campaign B7 (#847): each unit's medians over the rounds of the eight-lane reading by the rule of the claim tree as it
# is, forced huge (no unit large: claims) and forced base (every unit large), the fault-in tree, main and #791's head;
# their changes against the faster of main and the head (#847's bound); the every-lane walks' spread over the rounds;
# source order's medians; and for each threshold T of the unit's tokens, the composite of `huge` below T and `base`
# from T on.
#   b7sum.py LOG TREE FAULT MAIN HEAD
import collections, re, statistics, sys
log, tree, fault, main, head = sys.argv[1:6]
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
        cur['source_order'] = float(f['source_order'])
    elif cur is not None and line.startswith('checker-deferred:   lanes=') and 'active=' in line:
        f = dict(fieldre.findall(line))
        cur['readings'][int(f['lanes'])] = {k: float(v) for k, v in f.items() if re.match(r'^-?[\d.]+$', v)}
    elif cur is not None and line.startswith('exit='):
        cur['exit'] = line.split()[0]
bad = [(k, r['round']) for k, rs in runs.items() for r in rs if r.get('exit') != 'exit=0']
def med(name, unit, field, lanes=8):
    values = [r['readings'][lanes][field] for r in runs[(name, unit)] if lanes in r['readings'] and field in r['readings'][lanes]]
    return statistics.median(values) if values else None
def source(name, unit):
    values = [r['source_order'] for r in runs[(name, unit)] if 'source_order' in r]
    return statistics.median(values) if values else None
def spread(name, unit):
    values = [r['readings'][8]['walks'] for r in runs[(name, unit)] if 8 in r['readings']]
    return max(values) - min(values) if len(values) > 1 else float('nan')
units = sorted({u for (_, u) in runs}, key=lambda u: tokens.get(u, 0))
names = [tree, tree + '-huge', tree + '-base', fault, main, head]
labels = ['as is', 'huge', 'base', 'fault-in', 'main', 'head']
rounds = collections.Counter(len(runs[(tree, u)]) for u in units)
print(f'runs: {sum(len(v) for v in runs.values())}, rounds per unit: {dict(rounds)}, failed: {bad[:5]}')
print('| Unit | Tokens | Lanes: as is, huge, base, fault-in, main, head | As is | Huge | Base | Fault-in | Main | Head | As is against the faster of main and head | Fault-in against it | As is against fault-in | Claimed | Spread: huge, base |')
print('| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |')
rows = []
for u in units:
    whole = [med(n, u, 'whole') for n in names]
    if None in whole:
        continue
    lanes = [med(n, u, 'active') for n in names]
    claimed = (med(tree, u, 'claimed'), med(tree + '-huge', u, 'claimed'))
    spreads = (spread(tree + '-every-huge', u), spread(tree + '-every-base', u))
    sources = [source(n, u) for n in names]
    rows.append(dict(unit=u, tokens=tokens[u], whole=whole, lanes=lanes, spreads=spreads, sources=sources))
    bound = min(whole[4], whole[5])
    cl = '/'.join('-' if c is None else str(int(c)) for c in claimed)
    print(f'| `{u}.c` | {tokens[u]} | {"/".join(str(int(l)) for l in lanes)} | ' + ' | '.join(f'{w:.2f}' for w in whole) + ' | '
          + f'{100 * (whole[0] / bound - 1):+.1f}% | {100 * (whole[3] / bound - 1):+.1f}% | {100 * (whole[0] / whole[3] - 1):+.1f}% | {cl} | {spreads[0]:.2f}, {spreads[1]:.2f} |')
def summary(get, label):
    ch = [get(r) for r in rows]
    worst = rows[ch.index(max(ch))]['unit']
    print(f'{label}: median {statistics.median(ch):+.2f}% ({min(ch):+.1f} to {max(ch):+.1f}, worst {worst}), over +1%: {sum(c > 1 for c in ch)}, over +2%: {sum(c > 2 for c in ch)}')
print()
bound = lambda r: min(r['whole'][4], r['whole'][5])
for i in (0, 1, 2, 3):
    summary(lambda r, i=i: 100 * (r['whole'][i] / bound(r) - 1), f'{labels[i]} against the faster of main and head')
for i in (0, 3):
    summary(lambda r, i=i: 100 * (r['whole'][i] / r['whole'][4] - 1), f'{labels[i]} against main')
    summary(lambda r, i=i: 100 * (r['whole'][i] / r['whole'][5] - 1), f'{labels[i]} against head')
summary(lambda r: 100 * (r['whole'][5] / r['whole'][4] - 1), 'head against main')
summary(lambda r: 100 * (r['whole'][0] / r['whole'][3] - 1), 'as is against fault-in')
summary(lambda r: 100 * (r['whole'][1] / r['whole'][2] - 1), 'huge against base')
for k, label in ((0, 'huge'), (1, 'base')):
    s = [r['spreads'][k] for r in rows]
    print(f'every-lane walks spread, {label}: median {statistics.median(s):.2f}, highest {max(s):.2f} ({rows[s.index(max(s))]["unit"]})')
over = [r['unit'] for r in rows if r['spreads'][0] > r['spreads'][1]]
print(f'units whose huge spread is above base: {len(over)} {over}')
print()
print('source order (each run\'s source-order reading):')
summary(lambda r: 100 * (r['sources'][0] / r['sources'][5] - 1), 'as is against head')
summary(lambda r: 100 * (r['sources'][0] / r['sources'][4] - 1), 'as is against main')
summary(lambda r: 100 * (r['sources'][5] / r['sources'][4] - 1), 'head against main')
print()
print('threshold T: each unit huge below T, base from T on, against the faster of main and head')
for t in sorted({r['tokens'] for r in rows} | {48640}):
    worst = [100 * ((r['whole'][1] if r['tokens'] < t else r['whole'][2]) / bound(r) - 1) for r in rows]
    print(f'  T={t:7d}: median {statistics.median(worst):+.2f}%, worst {max(worst):+.2f}% ({rows[worst.index(max(worst))]["unit"]}), over +2%: {sum(w > 2 for w in worst)}')
