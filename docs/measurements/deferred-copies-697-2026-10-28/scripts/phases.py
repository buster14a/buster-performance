#!/usr/bin/env python3
# The phases of the frozen sqlite3.c's readings (3-runs.sh's logs of benchmark-checker-deferred, a process per run), by
# tree: each process's source order, its one-lane and its L-lane deferred readings (whole, top, environment, lanes'
# span, merge with its parts, rest), their medians over the processes with the lowest and highest, and each process's L
# lanes against its source order.
#   phases.py LOG...
import re, sys, statistics, collections
def fields(line):
    # The first of each key: a reading's line has positions= twice, in ns/token and then in ns/body.
    out = {}
    for m in re.finditer(r'(\w+)=([-\w./]+)', line):
        out.setdefault(m.group(1), m.group(2))
    return out
runs = collections.defaultdict(list)
for path in sys.argv[1:]:
    head = None
    unit = None
    readings = []
    parts = []
    for line in open(path, errors='replace'):
        line = line.rstrip('\n')
        if line.startswith('== round '):
            p = line.split()
            head = (p[3] + ' ' + p[4], int(p[6]))
            unit = None; readings = []; parts = []
        elif line.startswith('checker-deferred: file=') and head:
            unit = fields(line)
        elif "merge's parts:" in line and head:
            parts.append(fields(line))
        elif line.startswith('checker-deferred:   lanes=') and ' active=' in line and head and unit:
            readings.append(fields(line))
        if head and unit and len(readings) == 2 and len(parts) == 2:
            runs[head[0]].append((unit, readings, parts))
            head = None
keys = ['whole', 'top', 'environment', 'lanes_span', 'walks', 'positions', 'merge', 'rest']
part_keys = ['replay', 'tables', 'events', 'tags', 'pass', 'rest']
def f(x):
    return float(x.split('/')[0]) if x is not None else float('nan')
for run, items in runs.items():
    print('== %s: %d processes, tokens %s, bodies %s' % (run, len(items), items[0][0].get('tokens'), items[0][0].get('bodies')))
    so = [f(u['source_order']) for u, r, p in items]
    print('  source order          %8.2f (%.2f to %.2f)' % (statistics.median(so), min(so), max(so)))
    for i in range(2):
        lanes = items[0][1][i]['lanes']
        print('  deferred, %s lane(s), active %s' % (lanes, items[0][1][i]['active']))
        for k in keys:
            v = [f(r[i].get(k)) for u, r, p in items]
            print('    %-18s %8.3f (%.3f to %.3f)' % (k, statistics.median(v), min(v), max(v)))
        for k in part_keys:
            v = [f(p[i].get(k)) for u, r, p in items]
            print("    merge's %-10s %8.3f (%.3f to %.3f)" % (k, statistics.median(v), min(v), max(v)))
        ratio = [100.0 * (f(r[i]['whole']) / f(u['source_order']) - 1.0) for u, r, p in items]
        print('    against source order, each process: %+.1f%% (%+.1f to %+.1f)' % (statistics.median(ratio), min(ratio), max(ratio)))
