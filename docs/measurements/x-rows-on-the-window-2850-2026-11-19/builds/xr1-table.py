#!/usr/bin/env python3
# xr1-table.py: the first build's readings (builds/9700x/xr1), whose report has no reads' part of its own: the
# median and the range of its on runs' ticks a record swept, and of each part.
import re, glob, statistics
for corpus in ('sqlite3', 'lua', 'musl'):
    vals = []; parts = {}
    for p in sorted(glob.glob('9700x/xr1/rows-on*-%s-*.txt' % corpus)):
        t = open(p, errors='replace').read()
        m = re.search(r"window rows ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): (.*?); the reference", t)
        vals.append(float(m.group(1)))
        for name, v in re.findall(r"([a-z' ]+)=\d+ \(([\d.]+)\)", m.group(3)):
            parts.setdefault(name.strip(), []).append(float(v))
    print("%-8s the rows' sweeps, a record swept  %6.2f (%.2f to %.2f)  [%d runs]" % (corpus, statistics.median(vals), min(vals), max(vals), len(vals)))
    for k, v in parts.items():
        print("%-8s %-33s %6.2f (%.2f to %.2f)" % (corpus, k, statistics.median(v), min(v), max(v)))
