#!/usr/bin/env python3
# medians.py RESULTS LABEL...: each label's median, least and greatest cycles and instructions a node over its -f1 to -f10 runs,
# by file and sweep set. (results/medians.txt: parent v3; results/medians-main-head.txt: main head.)
import sys, re, statistics, os
results = sys.argv[1]
files = ['time-sqlite3', 'time-sqlite3-repeat2', 'time-lua', 'time-lua-repeat2']
sweeps = ['T', 'T+C', 'T+C+X']
pattern = re.compile(r'time sweeps=(\S+) passes=\d+ repeat=\d+ .* per-evaluated-node: cycles=([0-9.]+) instructions=([0-9.]+)')
for f in files:
    for label in sys.argv[2:]:
        values = {s: ([], []) for s in sweeps}
        for k in range(1, 11):
            path = os.path.join(results, label, '%s-f%d.txt' % (f, k))
            for line in open(path):
                m = pattern.search(line)
                if m:
                    values[m.group(1)][0].append(float(m.group(2)))
                    values[m.group(1)][1].append(float(m.group(3)))
        row = []
        for s in sweeps:
            c, i = values[s]
            row.append('%s %.1f (%.1f-%.1f) %.1f n=%d' % (s, statistics.median(c), min(c), max(c), statistics.median(i), len(c)))
        print('%-22s %-7s %s' % (f, label, ' | '.join(row)))
