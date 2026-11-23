#!/usr/bin/env python3
# keep-reduce.py OUT: per workload, each setting's medians and its paired difference from setting 0 a round (the mean of a
# round's two runs of each setting), and whether every run's objects, diagnostics and status are one set.
import sys, glob, os, statistics, collections
out = sys.argv[1]
runs = collections.defaultdict(lambda: collections.defaultdict(lambda: collections.defaultdict(list)))
shas = collections.defaultdict(set)
for path in glob.glob(os.path.join(out, '*.perf')):
    name = os.path.basename(path)[:-5]
    workload, r, p, s = name.split('.')
    values = {}
    for line in open(path):
        parts = line.strip().split(',')
        if len(parts) > 3 and parts[0].replace('.', '').isdigit():
            values[parts[2]] = float(parts[0])
    shas[workload].add(open(path[:-5] + '.sha').read().strip())
    runs[workload][int(r[1:])][s[1:]].append(values)
metrics = [('wall ms', 'duration_time', 1e6), ('user cycles M', 'cycles:u', 1e6), ('kernel cycles M', 'cycles:k', 1e6), ('user instructions M', 'instructions:u', 1e6), ('page faults', 'page-faults', 1)]
for workload in ('twice', 'sqlite', 'mixed', 'lua', 'musl'):
    if workload not in runs: continue
    rounds = runs[workload]
    print(f'== {workload}: {len(rounds)} rounds; distinct (status, objects, diagnostics): {len(shas[workload])}')
    print('%-22s %12s %12s %12s   %-22s %-22s' % ('metric', 'off', 'sites', 'all', 'sites less off (lower)', 'all less off (lower)'))
    for label, key, scale in metrics:
        per = {s: [statistics.mean(v[key] for v in rounds[r][s]) / scale for r in sorted(rounds)] for s in ('0', '2', '1')}
        d2 = [b - a for a, b in zip(per['0'], per['2'])]; d1 = [b - a for a, b in zip(per['0'], per['1'])]
        print('%-22s %12.3f %12.3f %12.3f   %+10.3f (%d/%d)      %+10.3f (%d/%d)' % (label, statistics.median(per['0']), statistics.median(per['2']), statistics.median(per['1']),
              statistics.median(d2), sum(1 for x in d2 if x < 0), len(d2), statistics.median(d1), sum(1 for x in d1 if x < 0), len(d1)))
