#!/usr/bin/env python3
# keep4-reduce.py OUT: per workload, the medians with the pages discarded (0) and kept (1) and the paired difference a
# round (the mean of a round's two runs of each), and whether every run's status, objects and diagnostics are one set.
import sys, glob, os, statistics, collections
out = sys.argv[1]
runs = collections.defaultdict(lambda: collections.defaultdict(lambda: collections.defaultdict(list)))
shas = collections.defaultdict(set)
for path in glob.glob(os.path.join(out, '*.perf')):
    workload, r, p, s = os.path.basename(path)[:-5].split('.')
    values = {}
    for line in open(path):
        parts = line.strip().split(',')
        if len(parts) > 3 and parts[0].replace('.', '').isdigit():
            values[parts[2]] = float(parts[0])
    if 'duration_time' in values:
        values['duration_time'] = values['duration_time'] / 1e6 if values['duration_time'] > 1e5 else values['duration_time'] * 1e3
    shas[workload].add(open(path[:-5] + '.sha').read().strip())
    runs[workload][int(r[1:])][s[1:]].append(values) if s != 'spoison' else None
metrics = [('wall ms', 'duration_time', 1), ('user cycles M', 'cycles:u', 1e6), ('kernel cycles M', 'cycles:k', 1e6), ('user instructions M', 'instructions:u', 1e6), ('page faults', 'page-faults', 1)]
for workload in ('twice', 'sqlite', 'mixed', 'lua', 'musl'):
    if workload not in runs: continue
    rounds = runs[workload]
    print(f'== {workload}: {len(rounds)} rounds; distinct (status, objects, diagnostics): {len(shas[workload])}')
    print('%-22s %12s %12s %12s   %s' % ('metric', 'main', 'discards kept', 'and the pool', 'discards kept less main (lower)   both less main (lower)'))
    for label, key, scale in metrics:
        per = {s: [statistics.mean(v[key] for v in rounds[r][s]) / scale for r in sorted(rounds)] for s in ('d0', 'd1', 'p2d1')}
        d = [b - a for a, b in zip(per['d0'], per['d1'])]; e = [b - a for a, b in zip(per['d0'], per['p2d1'])]
        print('%-22s %12.3f %12.3f %12.3f   %+10.3f (%d/%d)   %+10.3f (%d/%d)' % (label, statistics.median(per['d0']), statistics.median(per['d1']), statistics.median(per['p2d1']), statistics.median(d), sum(1 for x in d if x < 0), len(d), statistics.median(e), sum(1 for x in e if x < 0), len(e)))
