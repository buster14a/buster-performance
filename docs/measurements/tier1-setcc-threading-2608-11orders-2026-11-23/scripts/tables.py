#!/usr/bin/env python3
# tables.py RECORD: record2.sh's runs.tsv, execute.tsv and cost.tsv summarized as Markdown. Each order's figure is
# perf stat's mean of 3 runs (runs.tsv) or perf record's luaV_execute period sum (execute.tsv); a tree's figure is
# its median over the orders, with the orders' range.
import sys, statistics, math, os
rec = sys.argv[1]
def parse(line):
    f = line.rstrip('\n').split('\t')
    kv = dict(x.split('=', 1) for x in f[3:] if '=' in x)
    return f[0], int(f[1]) if f[1].isdigit() else f[1], f[2], kv
runs = {}
for line in open(os.path.join(rec, 'runs.tsv')):
    t, k, s, kv = parse(line)
    runs.setdefault((t, s), {})[k] = (float(kv['cycles:u']), float(kv['instructions:u']))
scripts = ['arithmetic', 'calls', 'closures', 'strings', 'tables']
orders = sorted(set(k for (t, s), d in runs.items() for k in d))
print(f'Orders timed: {len(orders)} ({", ".join(map(str, orders))}).\n')
print('| Script | base cycles (M), median [range] | head cycles (M), median [range] | cycles head/base | head faster at | instructions head/base |')
print('| --- | ---: | ---: | ---: | ---: | ---: |')
gc, gi = [], []
for s in scripts:
    b = runs[('base', s)]; h = runs[('head', s)]
    ks = [k for k in orders if k in b and k in h]
    bc = [b[k][0] for k in ks]; hc = [h[k][0] for k in ks]
    bi = statistics.median(b[k][1] for k in ks); hi = statistics.median(h[k][1] for k in ks)
    rc = statistics.median(hc) / statistics.median(bc); ri = hi / bi
    faster = sum(1 for k in ks if h[k][0] < b[k][0])
    gc.append(rc); gi.append(ri)
    print(f'| {s} | {statistics.median(bc)/1e6:.1f} [{min(bc)/1e6:.1f}, {max(bc)/1e6:.1f}] | {statistics.median(hc)/1e6:.1f} [{min(hc)/1e6:.1f}, {max(hc)/1e6:.1f}] | {rc:.4f} | {faster} of {len(ks)} | {ri:.4f} |')
g = lambda v: math.exp(sum(map(math.log, v)) / len(v))
print(f'| geometric mean | | | {g(gc):.4f} | | {g(gi):.4f} |\n')
tot = {}
for (t, s), d in runs.items():
    for k, (c, i) in d.items():
        tot.setdefault((t, k), [0, 0]); tot[(t, k)][0] += c; tot[(t, k)][1] += i
ks = [k for k in orders if ('base', k) in tot and ('head', k) in tot]
bt = [tot[('base', k)][0] for k in ks]; ht = [tot[('head', k)][0] for k in ks]
print(f'Five scripts\' cycles summed: base median {statistics.median(bt)/1e6:.1f} M [{min(bt)/1e6:.1f}, {max(bt)/1e6:.1f}], head {statistics.median(ht)/1e6:.1f} M [{min(ht)/1e6:.1f}, {max(ht)/1e6:.1f}], head/base {statistics.median(ht)/statistics.median(bt):.4f}; head below base at {sum(1 for k in ks if tot[("head", k)][0] < tot[("base", k)][0])} of {len(ks)} orders.\n')
ex = {}
for line in open(os.path.join(rec, 'execute.tsv')):
    f = line.split()
    if len(f) >= 4:
        ex[(f[0], int(f[1]))] = (float(f[2]), float(f[3]))
ks = [k for k in orders if ('base', k) in ex and ('head', k) in ex]
print('| Order | base luaV_execute cycles (M) | head (M) | head/base | base share | head share |')
print('| ---: | ---: | ---: | ---: | ---: | ---: |')
for k in ks:
    b, h = ex[('base', k)], ex[('head', k)]
    print(f'| {k} | {b[0]/1e6:.1f} | {h[0]/1e6:.1f} | {h[0]/b[0]:.4f} | {b[0]/b[1]:.3f} | {h[0]/h[1]:.3f} |')
be = [ex[('base', k)][0] for k in ks]; he = [ex[('head', k)][0] for k in ks]
print(f'| median | {statistics.median(be)/1e6:.1f} | {statistics.median(he)/1e6:.1f} | {statistics.median(he)/statistics.median(be):.4f} | | |')
print(f'\nluaV_execute\'s cycles: base [{min(be)/1e6:.1f}, {max(be)/1e6:.1f}] M, head [{min(he)/1e6:.1f}, {max(he)/1e6:.1f}] M; head below base at {sum(1 for k in ks if ex[("head", k)][0] < ex[("base", k)][0])} of {len(ks)} orders.\n')
p = os.path.join(rec, 'cost.tsv')
if os.path.exists(p):
    cost = {}
    for line in open(p):
        t, r, what, kv = parse(line)
        if 'cycles:u' in kv:
            cost.setdefault((t, what), []).append((float(kv['cycles:u']), float(kv['instructions:u'])))
    print('| Compile (--lanes 1 -c) | base cycles (M) [range] | head cycles (M) [range] | cycles head/base | instructions head/base |')
    print('| --- | ---: | ---: | ---: | ---: |')
    for what in ['lvm', 'sqlite']:
        b = cost.get(('base', what)); h = cost.get(('head', what))
        if b and h:
            bc = [x[0] for x in b]; hc = [x[0] for x in h]
            print(f'| {"lvm.c" if what == "lvm" else "sqlite3.c -O2"} | {statistics.median(bc)/1e6:.1f} [{min(bc)/1e6:.1f}, {max(bc)/1e6:.1f}] | {statistics.median(hc)/1e6:.1f} [{min(hc)/1e6:.1f}, {max(hc)/1e6:.1f}] | {statistics.median(hc)/statistics.median(bc):.4f} | {statistics.median(x[1] for x in h)/statistics.median(x[1] for x in b):.4f} |')
