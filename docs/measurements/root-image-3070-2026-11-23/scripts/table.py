#!/usr/bin/env python3
# usage: table.py OUTDIR [BASE]   medians over the rounds of each configuration and workload, M cycles; with BASE, each
# configuration's change of all cycles against it, paired by round (the median, and in how many rounds it was lower).
import sys, glob, re, statistics as st, collections
out = sys.argv[1]
base = sys.argv[2] if len(sys.argv) > 2 else None
data = collections.defaultdict(dict)
for path in glob.glob(out + '/perf-*.csv'):
    m = re.match(r'.*/perf-([a-z0-9]+)-(.+)\.(\d+)\.csv$', path)
    label, build, rnd = m.group(1), m.group(2), int(m.group(3))
    row = {}
    for line in open(path):
        f = line.strip().split(',')
        if len(f) > 2 and f[0] not in ('', '<not counted>') and not line.startswith('#'):
            try: row[f[2]] = float(f[0])
            except ValueError: pass
    data[(label, build)][rnd] = row
labels = ['empty', 'musl1', 'musl4', 'lua1']
builds = sorted({b for (_, b) in data})
print('| workload | configuration | user | kernel | all | user instructions | kernel instructions | faults | rounds |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for l in labels:
    for b in builds:
        rows = data.get((l, b), {})
        if not rows: continue
        med = lambda k: st.median(r[k] for r in rows.values() if k in r)
        u, k = med('cycles:u') / 1e6, med('cycles:k') / 1e6
        a = st.median((r['cycles:u'] + r['cycles:k']) / 1e6 for r in rows.values())
        print('| %s | %s | %.1f | %.1f | %.1f | %.1f | %.1f | %d | %d |' % (l, b, u, k, a, med('instructions:u') / 1e6, med('instructions:k') / 1e6, med('page-faults'), len(rows)))
if base:
    print()
    print('| workload | configuration | all cycles against %s, paired | lower in | kernel cycles | user cycles |' % base)
    print('| --- | --- | ---: | ---: | ---: | ---: |')
    for l in labels:
        for b in builds:
            if b == base: continue
            rb, rr = data.get((l, base), {}), data.get((l, b), {})
            rounds = sorted(set(rb) & set(rr))
            if not rounds: continue
            tot = lambda r: r['cycles:u'] + r['cycles:k']
            d = [tot(rr[r]) / tot(rb[r]) - 1 for r in rounds]
            dk = [rr[r]['cycles:k'] / rb[r]['cycles:k'] - 1 for r in rounds]
            du = [rr[r]['cycles:u'] / rb[r]['cycles:u'] - 1 for r in rounds]
            print('| %s | %s | %+.1f%% | %d of %d | %+.1f%% | %+.1f%% |' % (l, b, 100 * st.median(d), sum(1 for x in d if x < 0), len(d), 100 * st.median(dk), 100 * st.median(du)))
