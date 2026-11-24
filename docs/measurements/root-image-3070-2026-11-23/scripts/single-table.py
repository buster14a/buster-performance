#!/usr/bin/env python3
# usage: single-table.py OUTDIR   the process-a-unit loops' medians, M cycles, and each against base paired by round.
import sys, glob, re, statistics as st, collections
out = sys.argv[1]
data = collections.defaultdict(dict)
for path in glob.glob(out + '/perf-*.csv'):
    m = re.match(r'.*/perf-([a-z0-9]+)-(.+)\.(\d+)\.csv$', path)
    row = {}
    for line in open(path):
        f = line.strip().split(',')
        if len(f) > 2 and not line.startswith('#'):
            try: row[f[2]] = float(f[0])
            except ValueError: pass
    data[(m.group(1), m.group(2))][int(m.group(3))] = row
print('| loop | compiler | user | kernel | all | user instructions | faults | rounds |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |')
for kind in ('empty', 'musl'):
    for build in ('base', 'head'):
        rows = data.get((kind, build), {})
        if not rows: continue
        med = lambda k: st.median(r[k] for r in rows.values())
        a = st.median(r['cycles:u'] + r['cycles:k'] for r in rows.values())
        print('| %s | %s | %.1f | %.1f | %.1f | %.1f | %d | %d |' % (kind, build, med('cycles:u') / 1e6, med('cycles:k') / 1e6, a / 1e6, med('instructions:u') / 1e6, med('page-faults'), len(rows)))
print()
for kind in ('empty', 'musl'):
    rb, rh = data.get((kind, 'base'), {}), data.get((kind, 'head'), {})
    rounds = sorted(set(rb) & set(rh))
    if rounds:
        d = [(rh[r]['cycles:u'] + rh[r]['cycles:k']) / (rb[r]['cycles:u'] + rb[r]['cycles:k']) - 1 for r in rounds]
        print('%s: head against base, paired: %+.2f%% (lower in %d of %d)' % (kind, 100 * st.median(d), sum(1 for x in d if x < 0), len(d)))
