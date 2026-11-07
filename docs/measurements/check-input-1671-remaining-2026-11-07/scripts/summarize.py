#!/usr/bin/env python3
# usage: summarize.py OUT A B: the medians over ab.sh's rounds of each perf stat event for builds A and B, their
# differences, the round-by-round median difference of task-clock, and check-input from each measure-compile run.
import sys, glob, statistics, re
out, a, b = sys.argv[1:4]
def rounds(x):
    result = {}
    for f in glob.glob(f"{out}/stat-{x}-*.csv"):
        r = int(re.search(r"-(\d+)\.csv$", f).group(1))
        for line in open(f):
            p = line.strip().split(",")
            if len(p) > 3 and p[0] and p[0][0].isdigit():
                result.setdefault(p[2], {})[r] = float(p[0])
    return result
ra, rb = rounds(a), rounds(b)
for event in ra:
    ma, mb = statistics.median(ra[event].values()), statistics.median(rb[event].values())
    print(f"{event}: {a} {ma:,.3f} {b} {mb:,.3f} difference {100 * (mb - ma) / ma:+.2f}% (n={len(ra[event])})")
paired = [100 * (rb["task-clock"][r] - ra["task-clock"][r]) / ra["task-clock"][r] for r in ra["task-clock"]]
print(f"task-clock round by round: median {statistics.median(paired):+.2f}%, {sum(p < 0 for p in paired)} of {len(paired)} rounds lower")
for f in sorted(glob.glob(f"{out}/measure-*.txt")):
    for line in open(f):
        if re.match(r"\s+check-input(\.expressions)?\s|\s+expressions\.actions", line):
            print(f.split("/")[-1], line.rstrip())
