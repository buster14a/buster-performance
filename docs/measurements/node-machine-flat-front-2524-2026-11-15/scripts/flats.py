#!/usr/bin/env python3
# flats.py FILE...: over the given files (runs of one build, options and corpus), the medians of the lean front's ticks,
# the flat front's, its compaction's and its stages', and the walk's compaction's, in ticks and ms at the TSC's
# 3792.9 MHz, with the flat front's counts from the first file.
import sys, re, statistics
rows = {}
counts = []
for path in sys.argv[1:]:
    for line in open(path, errors="replace"):
        m = re.search(r'node-shadow: front ticks=(\d+)', line)
        if m:
            rows.setdefault('lean', []).append(int(m.group(1)))
        m = re.search(r'node-shadow: flat front ticks=(\d+) compact-ticks=(\d+)', line)
        if m:
            rows.setdefault('flat', []).append(int(m.group(1)))
            rows.setdefault('flat-compact', []).append(int(m.group(2)))
        m = re.search(r'node-shadow: flat front stage ticks classify=(\d+) leaves=(\d+) places=(\d+) records=(\d+) empties=(\d+)', line)
        if m:
            for name, value in zip(['classify', 'leaves', 'places', 'records', 'empties'], m.groups()):
                rows.setdefault(' ' + name, []).append(int(value))
        m = re.search(r'node-shadow: walk prepare ticks compact=(\d+) identifiers=(\d+) literals=(\d+)', line)
        if m:
            rows.setdefault('walk-compact', []).append(int(m.group(1)))
            rows.setdefault('literals', []).append(int(m.group(3)))
        if path == sys.argv[1] and re.search(r'node-shadow: (flat front (after|before|against)|front (after|before))', line):
            counts.append(line.rstrip())
mhz = 3792.9
for name in ['lean', 'flat', ' classify', ' leaves', ' places', ' records', ' empties', 'flat-compact', 'walk-compact', 'literals']:
    if name in rows:
        values = rows[name]
        median = statistics.median(values)
        print('%-13s %12d ticks  %7.3f ms   (runs: %s)' % (name, median, median / mhz / 1000, ' '.join('%.2f' % (v / mhz / 1000) for v in values)))
for line in counts:
    print(line)
