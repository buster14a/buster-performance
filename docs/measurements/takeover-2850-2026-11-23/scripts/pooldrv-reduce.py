#!/usr/bin/env python3
# pool-reduce.py OUT: the settings' medians and each pool setting's paired difference from anonymous memory a round.
import sys, glob, os, statistics, collections
out = sys.argv[1]
runs = collections.defaultdict(lambda: collections.defaultdict(list)); shas = collections.defaultdict(set)
for path in glob.glob(os.path.join(out, 'r*.perf')):
    r, p, s = os.path.basename(path)[:-5].split('.')
    values = {}
    for line in open(path):
        parts = line.strip().split(',')
        if len(parts) > 3 and parts[0].replace('.', '').isdigit(): values[parts[2]] = float(parts[0])
    if 'duration_time' in values: values['duration_time'] = values['duration_time'] / 1e6 if values['duration_time'] > 1e5 else values['duration_time'] * 1e3
    runs[int(r[1:])][s].append(values); shas[s].add(open(path[:-5] + '.sha').read().strip())
print('rounds', len(runs), '; distinct (status, object, diagnostics) by setting:', {s: len(v) for s, v in shas.items()}, '; one object across settings:', len({x.split()[1] for v in shas.values() for x in v}) == 1)
print('%-22s %12s %12s %12s   %-24s %-24s' % ('metric', 'main', 'used before', 'the file', 'used before less main', 'the file less main'))
for label, key, scale in [('wall ms', 'duration_time', 1), ('user cycles M', 'cycles:u', 1e6), ('kernel cycles M', 'cycles:k', 1e6), ('user instructions M', 'instructions:u', 1e6), ('page faults', 'page-faults', 1)]:
    per = {s: [statistics.mean(v[key] for v in runs[r][s]) / scale for r in sorted(runs)] for s in 'atp'}
    db = [y - x for x, y in zip(per['a'], per['t'])]; dc = [y - x for x, y in zip(per['a'], per['p'])]
    print('%-22s %12.3f %12.3f %12.3f   %+10.3f (%d/%d lower)   %+10.3f (%d/%d lower)' % (label, statistics.median(per['a']), statistics.median(per['t']), statistics.median(per['p']), statistics.median(db), sum(1 for x in db if x < 0), len(db), statistics.median(dc), sum(1 for x in dc if x < 0), len(dc)))
