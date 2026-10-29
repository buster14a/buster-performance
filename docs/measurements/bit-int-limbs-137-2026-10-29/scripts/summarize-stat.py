#!/usr/bin/env python3
# Medians of perf stat's CSV files (-x,) per tree and event: summarize-stat.py PREFIX TREE... reads PREFIX-TREE-N.csv.
import glob, statistics, sys
prefix, trees = sys.argv[1], sys.argv[2:]
reference = {}
for t in trees:
    values = {}
    for path in sorted(glob.glob(f"{prefix}-{t}-*.csv")):
        for line in open(path):
            fields = line.strip().split(",")
            if len(fields) > 2 and fields[0].isdigit():
                values.setdefault(fields[2], []).append(int(fields[0]))
    for event, v in values.items():
        median = statistics.median(v)
        line = f"{prefix} {t} {event}: median {median:,} of {len(v)} ({', '.join(f'{x:,}' for x in v)})"
        if event in reference:
            line += f" | {median - reference[event]:+,} ({100 * (median / reference[event] - 1):+.3f}%)"
        else:
            reference[event] = median
        print(line)
