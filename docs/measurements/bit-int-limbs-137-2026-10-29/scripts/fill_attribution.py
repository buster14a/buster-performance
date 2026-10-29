#!/usr/bin/env python3
# Prints the README's attribution table from at3's reports: per function, the mean instructions a process over each
# tree's runs, with the differences' standard errors, for the functions whose difference is largest.
import collections, glob, math, re, statistics, sys
directory = sys.argv[1]
trees = ("qf2", "lb3", "cq3")
runs = {}
for t in trees:
    runs[t] = []
    for path in sorted(glob.glob(f"{directory}/at3-{t}-*.report")):
        d = collections.Counter()
        for line in open(path):
            m = re.match(r"\s*(\d+)\s+(\d+)\s+\[\.\]\s+(\S+)", line)
            if m:
                d[m.group(3)] += int(m.group(1))
        runs[t].append(d)
def mean(t, k):
    return statistics.mean(d[k] for d in runs[t])
def se(t, k):
    v = [d[k] for d in runs[t]]
    return statistics.variance(v) / len(v)
keys = set().union(*runs["qf2"], *runs["lb3"], *runs["cq3"])
def score(k):
    return max(abs(mean("lb3", k) - mean("qf2", k)), abs(mean("cq3", k) - mean("lb3", k)))
print("| Function | #837 | #857 − #837 | #858 − #857 | #858 − #837 |")
print("| --- | ---: | ---: | ---: | ---: |")
for k in sorted(keys, key=lambda k: -score(k))[:int(sys.argv[2]) if len(sys.argv) > 2 else 12]:
    def cell(a, b):
        return f"{(mean(b, k) - mean(a, k)) / 1e6:+.1f} ± {math.sqrt(se(a, k) + se(b, k)) / 1e6:.1f}"
    print(f"| `{k}` | {mean('qf2', k) / 1e6:.1f} | {cell('qf2', 'lb3')} | {cell('lb3', 'cq3')} | {cell('qf2', 'cq3')} |")
total = {t: statistics.mean(sum(d.values()) for d in runs[t]) for t in trees}
print(f"\ntotals: " + ", ".join(f"{t} {total[t]:,.0f}" for t in trees), f"runs: " + ", ".join(f"{t} {len(runs[t])}" for t in trees))
