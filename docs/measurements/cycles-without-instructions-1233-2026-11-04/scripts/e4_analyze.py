#!/usr/bin/env python3
"""#1233 E3/E4: each executable (tree M or H, checker offset N) against main at offset 0, by event: median over runs
and copies, the difference paired by run (both copies) with its standard error; then the merge minus main over all
offsets, paired by run and copy, and over each subset of offsets given (--subset 0,16,32,48)."""
import sys, csv, statistics as st, collections
path = sys.argv[1]
subsets = [s.split(',') for s in sys.argv[2:]]
v = collections.defaultdict(dict)
bad = 0
for f in csv.reader(open(path)):
    if f[3] == '0':
        continue
    if f[7] != '0' or f[8].startswith('<') or (len(f) > 12 and f[12] not in ('100.00', '')):
        bad += 1; continue
    v[(f[5], f[6], int(f[3]))][f[10].replace(':u', '')] = float(f[8])
builds = sorted({k[0] for k in v}, key=lambda b: (b[0], int(b[1:])))
copies = sorted({k[1] for k in v}); runs = sorted({k[2] for k in v})
offsets = sorted({int(b[1:]) for b in builds})
ref = [b for b in builds if b[0] == 'M' and int(b[1:]) == 0][0]
print('bad', bad, 'builds', builds, 'runs', len(runs), 'copies', copies)
for e in ('cycles', 'instructions', 'de_no_dispatch_per_slot.no_ops_from_frontend', 'op_cache_hit_miss.op_cache_miss'):
    print(f'== {e}')
    refmed = st.median(v[(ref, c, r)][e] for c in copies for r in runs)
    refrun = {r: st.mean(v[(ref, c, r)][e] for c in copies) for r in runs}
    for b in builds:
        d = [st.mean(v[(b, c, r)][e] for c in copies) - refrun[r] for r in runs]
        med = st.median(v[(b, c, r)][e] for c in copies for r in runs)
        print(f'  {b:6s} median {med:.6g} ({100 * (med / refmed - 1):+.3f}%), paired {100 * st.mean(d) / refmed:+.3f}% ± {100 * st.stdev(d) / len(d) ** 0.5 / refmed:.3f}%')
    for name, offs in [('all', [str(o) for o in offsets])] + [(','.join(s), s) for s in subsets]:
        offs = [int(o) for o in offs]
        d = []
        for r in runs:
            for c in copies:
                h = st.mean(v[(b, c, r)][e] for b in builds if b[0] == 'H' and int(b[1:]) in offs)
                m = st.mean(v[(b, c, r)][e] for b in builds if b[0] == 'M' and int(b[1:]) in offs)
                d.append(h - m)
        hs = [st.median(v[(b, c, r)][e] for c in copies for r in runs) for b in builds if b[0] == 'H' and int(b[1:]) in offs]
        ms = [st.median(v[(b, c, r)][e] for c in copies for r in runs) for b in builds if b[0] == 'M' and int(b[1:]) in offs]
        print(f'  merge minus main over offsets {name}: {100 * st.mean(d) / refmed:+.3f}% ± {100 * st.stdev(d) / len(d) ** 0.5 / refmed:.3f}% (n={len(d)}); medians main {100 * (min(ms) / refmed - 1):+.3f}% to {100 * (max(ms) / refmed - 1):+.3f}%, merge {100 * (min(hs) / refmed - 1):+.3f}% to {100 * (max(hs) / refmed - 1):+.3f}%')
