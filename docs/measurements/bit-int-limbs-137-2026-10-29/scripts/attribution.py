#!/usr/bin/env python3
# Each function's user instructions in attr2.sh's and attr3.sh's profiles (perf report's periods), the mean over a
# tree's runs, and the largest differences between consecutive trees, each with its standard error from the runs'
# spread (attr3.sh's runs sample at other places in the same instructions; attr2.sh's, of one period, don't, so theirs
# understates the error): attribution.py PREFIX TREE... reads PREFIX-TREE-N.report.
import collections, glob, math, re, statistics, sys
prefix, trees = sys.argv[1], sys.argv[2:]
runs = {}
for t in trees:
    runs[t] = []
    for path in sorted(glob.glob(f"{prefix}-{t}-*.report")):
        d = collections.Counter()
        for line in open(path):
            m = re.match(r"\s*(\d+)\s+(\d+)\s+\[\.\]\s+(\S+)", line)
            if m:
                d[m.group(3)] += int(m.group(1))
        runs[t].append(d)
    print(f"{t}: {len(runs[t])} runs, periods summing to " + ", ".join(f"{sum(d.values()):,}" for d in runs[t]))
def mean(t, k):
    return statistics.mean(d[k] for d in runs[t])
def error(t, k):
    values = [d[k] for d in runs[t]]
    return statistics.variance(values) / len(values) if len(values) > 1 else 0.0
for a, b in zip(trees, trees[1:]) if len(trees) > 1 else []:
    keys = set().union(*runs[a], *runs[b])
    total = statistics.mean(sum(d.values()) for d in runs[b]) - statistics.mean(sum(d.values()) for d in runs[a])
    print(f"\n{a} -> {b}: {total / 1e6:+.2f}M instructions a process")
    for k in sorted(keys, key=lambda k: -abs(mean(b, k) - mean(a, k)))[:20]:
        print(f"  {(mean(b, k) - mean(a, k)) / 1e6:+8.2f}M ± {math.sqrt(error(a, k) + error(b, k)) / 1e6:5.2f}M"
              f"  {mean(a, k) / 1e6:9.1f}M -> {mean(b, k) / 1e6:9.1f}M  {k}")
