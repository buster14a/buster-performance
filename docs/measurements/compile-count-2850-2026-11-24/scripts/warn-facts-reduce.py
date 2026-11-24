#!/usr/bin/env python3
# Reduces warn-facts.sh's perf stat files: each variant's three rounds (11 runs each) against "none" of the same round.
import sys, os, statistics
d = sys.argv[1]
names = "none w unreachable operand-masks reach-scan edges unsequenced ignored-statement root-frames unselected-roots root-loop unevaluated-scan range-candidates evaluated-parts reach-parts walk-parts everything".split()
def read(name, round_):
    values = {}
    for line in open(os.path.join(d, "stat-%s-%d.csv" % (name, round_))):
        f = line.strip().split(",")
        if len(f) > 3 and f[0] and f[0][0].isdigit():
            values[f[2]] = float(f[0])
    return values
rows = {n: [read(n, r) for r in (1, 2, 3)] for n in names}
print("%-18s %9s %9s %8s %8s %8s %8s   %s" % ("left out", "ms", "d ms", "d Mcyc", "d Minst", "d kL1", "d kLLC", "d ms by round"))
for n in names:
    ms = [x["task-clock"] for x in rows[n]]
    by_round = [rows[n][i]["task-clock"] - rows["none"][i]["task-clock"] for i in range(3)]
    def delta(key, scale):
        return statistics.mean(rows[n][i][key] - rows["none"][i][key] for i in range(3)) / scale
    print("%-18s %9.2f %+9.2f %+8.2f %+8.2f %+8.0f %+8.0f   %s" % (n, statistics.mean(ms), statistics.mean(by_round), delta("cycles:u", 1e6), delta("instructions:u", 1e6), delta("L1-dcache-load-misses:u", 1e3), delta("cache-misses:u", 1e3), " ".join("%+.2f" % x for x in by_round)))
