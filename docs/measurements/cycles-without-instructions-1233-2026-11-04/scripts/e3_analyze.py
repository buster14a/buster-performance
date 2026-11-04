#!/usr/bin/env python3
"""#1233 E3: each build (tree and checker offset) against M00 by event: median over runs and copies, and the
difference paired by run (both copies), with its standard error; then each tree's mean over its four offsets."""
import sys, csv, statistics as st, collections
v = collections.defaultdict(dict)  # (build, copy, run) -> {event: value}
bad = 0
for f in csv.reader(open(sys.argv[1])):
    regime, cmd, group, run, pos, build, copy, status = f[:8]
    if run == '0':
        continue
    if status != '0' or f[8].startswith('<') or (len(f) > 12 and f[12] not in ('100.00', '')):
        bad += 1; continue
    v[(build, copy, int(run))][f[10].replace(':u', '')] = float(f[8])
print('bad', bad)
builds = sorted({k[0] for k in v}); runs = sorted({k[2] for k in v})
events = list(next(iter(v.values())).keys())
for e in events:
    print(f'== {e}')
    ref = {r: st.mean(v[('M00', c, r)][e] for c in ('c1', 'c2')) for r in runs}
    refmed = st.median(v[('M00', c, r)][e] for c in ('c1', 'c2') for r in runs)
    tree = collections.defaultdict(list)
    for b in builds:
        vals = [v[(b, c, r)][e] for c in ('c1', 'c2') for r in runs]
        per = {r: st.mean(v[(b, c, r)][e] for c in ('c1', 'c2')) for r in runs}
        d = [per[r] - ref[r] for r in runs]
        cm = [st.median(v[(b, c, r)][e] for r in runs) for c in ('c1', 'c2')]
        tree[b[0]].append(st.mean(d))
        print(f'  {b}: median {st.median(vals):.6g} ({100 * (st.median(vals) / refmed - 1):+.3f}%), paired {st.mean(d):+.4g} ± {st.stdev(d) / len(d) ** 0.5:.3g} ({100 * st.mean(d) / refmed:+.3f}%); copies {cm[0]:.6g} {cm[1]:.6g} ({100 * (cm[1] / cm[0] - 1):+.2f}%)')
    for t in tree:
        print(f'  tree {t}: mean over offsets {st.mean(tree[t]):+.4g} ({100 * st.mean(tree[t]) / refmed:+.3f}%), offsets from {min(tree[t]):+.4g} to {max(tree[t]):+.4g} ({100 * (max(tree[t]) - min(tree[t])) / refmed:.3f}% spread)')
