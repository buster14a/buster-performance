#!/usr/bin/env python3
# Reduces ab.sh's perf stat files: each variant's three rounds (11 runs each) against base of the same round.
import sys, os, statistics
d = sys.argv[1]
names = sorted({f[5:-6] for f in os.listdir(d) if f.startswith("stat-")}, key=lambda n: (n != "base", n == "base-w", n))
def read(name, round_):
    values = {}
    for line in open(os.path.join(d, "stat-%s-%d.csv" % (name, round_))):
        f = line.strip().split(",")
        if len(f) > 3 and f[0] and f[0][0].isdigit():
            values[f[2]] = float(f[0])
            values[f[2] + " sd%"] = float(f[3].rstrip("%")) if f[3].rstrip("%") else 0.0
    return values
rows = {n: [read(n, r) for r in (1, 2, 3)] for n in names}
print("%-8s %9s %9s %8s %8s %8s %8s %8s   %-22s %s" % ("variant", "ms", "d ms", "d Mcyc", "d Minst", "d kL1", "d kLLC", "d kBrM", "d ms by round", "ms by round (sd% of 11)"))
for n in names:
    ms = [x["task-clock"] for x in rows[n]]
    by_round = [rows[n][i]["task-clock"] - rows["base"][i]["task-clock"] for i in range(3)]
    def delta(key, scale):
        return statistics.mean(rows[n][i][key] - rows["base"][i][key] for i in range(3)) / scale
    print("%-8s %9.2f %+9.2f %+8.2f %+8.2f %+8.0f %+8.0f %+8.0f   %-22s %s" % (n, statistics.mean(ms), statistics.mean(by_round), delta("cycles:u", 1e6), delta("instructions:u", 1e6),
          delta("L1-dcache-load-misses:u", 1e3), delta("cache-misses:u", 1e3), delta("branch-misses:u", 1e3), " ".join("%+.2f" % x for x in by_round),
          " ".join("%.2f (%.2f%%)" % (rows[n][i]["task-clock"], rows[n][i]["task-clock sd%"]) for i in range(3))))
