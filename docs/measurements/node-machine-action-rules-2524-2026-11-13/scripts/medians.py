#!/usr/bin/env python3
# medians.py RESULTS LABEL...: each label's median, least and greatest cycles and instructions a taken evaluated node over
# its time-*-fN.txt runs (every N there is), by input and sweep set.
import sys, re, statistics, os, glob
results = sys.argv[1]
files = ['time-sqlite3', 'time-sqlite3-repeat2', 'time-lua', 'time-lua-repeat2']
sweeps = ['T', 'T+C', 'T+C+X']
pattern = re.compile(r'time sweeps=(\S+) passes=\d+ repeat=\d+ .* per-evaluated-node: cycles=([0-9.]+) instructions=([0-9.]+)')
for f in files:
    for label in sys.argv[2:]:
        values = {s: ([], []) for s in sweeps}
        for path in sorted(glob.glob(os.path.join(results, label, '%s-f*.txt' % f))):
            if not re.search(r'-f\d+\.txt$', path):
                continue
            for line in open(path):
                m = pattern.search(line)
                if m:
                    values[m.group(1)][0].append(float(m.group(2)))
                    values[m.group(1)][1].append(float(m.group(3)))
        row = []
        for s in sweeps:
            c, i = values[s]
            if c:
                row.append('%s %.1f (%.1f-%.1f) %.1f n=%d' % (s, statistics.median(c), min(c), max(c), statistics.median(i), len(c)))
        print('%-22s %-5s %s' % (f, label, ' | '.join(row)))
