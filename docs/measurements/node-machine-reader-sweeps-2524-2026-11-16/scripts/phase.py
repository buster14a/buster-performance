#!/usr/bin/env python3
# phase.py RESULTS TAG LABEL...: phase-o.sh's readings: for each label the three sweeps' cycles a taken node at each
# stack phase, with their least, median and greatest.
import os, re, statistics, sys
results, tag = sys.argv[1:3]
TAKEN = r'machine-taken expressions=(\d+) \([0-9.]+%\) evaluated-nodes=(\d+) '
def sweep(name):
    return r'time sweeps=%s passes=\d+ repeat=\d+ cycles=(\d+) instructions=(\d+) ticks=(\d+) ' % re.escape(name)
for label in sys.argv[3:]:
    rows = []
    for bytes_ in range(0, 4096, 128):
        path = os.path.join(results, label, 'phase-%s-%d.txt' % (tag, bytes_))
        if not os.path.exists(path):
            continue
        text = open(path, errors='replace').read()
        nodes = float(re.search(TAKEN, text).group(2))
        values = [float(re.search(sweep(name), text).group(1)) / nodes for name in ('T', 'T+C', 'T+C+X')]
        rows.append((bytes_, values))
    for k, name in enumerate(('T', 'T+C', 'T+C+X')):
        column = [v[k] for _, v in rows]
        print('%-4s %-6s least %.1f median %.1f greatest %.1f (%d phases): %s' % (label, name, min(column), statistics.median(column), max(column), len(column), ' '.join('%.1f' % v for v in column)))
