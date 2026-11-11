#!/usr/bin/env python3
# #1444 item 3: kstat.sh's perf stat CSVs: each build's mean of its rounds' means, per control and event, and its
# change against base. Usage: kstat-summary.py DIRECTORY
import collections, glob, os, re, sys
values = collections.defaultdict(list)
for path in glob.glob(os.path.join(sys.argv[1], "*.csv")):
    m = re.match(r"(.+)-(syntax|preprocess|tiny|hello)-(\d+)\.csv$", os.path.basename(path))
    if not m:
        continue
    for line in open(path):
        p = line.strip().split(",")
        if len(p) > 3 and p[0] and p[0][0].isdigit():
            values[(m.group(1), m.group(2), p[2])].append(float(p[0]))
events = ["task-clock", "page-faults", "cycles:u", "cycles:k"]
for control in ["syntax", "preprocess", "tiny", "hello"]:
    print(control)
    for event in events:
        row = []
        base = values.get(("base", control, event))
        for build in ["base", "bss2", "base-again"]:
            v = values.get((build, control, event))
            if v:
                mean = sum(v) / len(v)
                change = "" if build == "base" or not base else " (%+.2f%%)" % (100 * (mean / (sum(base) / len(base)) - 1))
                row.append("%s %.4g [%.4g..%.4g]%s" % (build, mean, min(v), max(v), change))
        print("  %-12s %s" % (event, "; ".join(row)))
