#!/usr/bin/env python3
# Reduces ab-pr.sh's perf stat files: head against base, with the default warnings and with -w, round by round.
import sys, os, statistics
d = sys.argv[1]
def read(v, r):
    values = {}
    for line in open(os.path.join(d, "stat-%s-%d.csv" % (v, r))):
        f = line.strip().split(",")
        if len(f) > 3 and f[0] and f[0][0].isdigit():
            values[f[2]] = float(f[0])
    return values
rows = {v: [read(v, r) for r in (1, 2, 3)] for v in ("base", "head", "base-w", "head-w")}
def line(label, a, b):
    ms = [rows[b][i]["task-clock"] - rows[a][i]["task-clock"] for i in range(3)]
    def delta(key, scale):
        return statistics.mean(rows[b][i][key] - rows[a][i][key] for i in range(3)) / scale
    print("%-28s %8.2f %8.2f %+7.2f %+8.2f %+8.2f %+7.0f   %s" % (label, statistics.mean(x["task-clock"] for x in rows[a]), statistics.mean(x["task-clock"] for x in rows[b]), statistics.mean(ms), delta("cycles:u", 1e6), delta("instructions:u", 1e6), delta("L1-dcache-load-misses:u", 1e3), " ".join("%+.2f" % x for x in ms)))
print("%-28s %8s %8s %7s %8s %8s %7s   %s" % ("", "a ms", "b ms", "d ms", "d Mcyc", "d Minst", "d kL1", "d ms by round"))
line("default: base -> head", "base", "head")
line("-w: base -> head", "base-w", "head-w")
line("base: default -> -w", "base", "base-w")
line("head: default -> -w", "head", "head-w")
