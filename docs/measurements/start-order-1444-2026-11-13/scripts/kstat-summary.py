#!/usr/bin/env python3
# #1444's open items: kstat.sh's perf stat CSVs: each build's mean of its rounds' means, per control and event, its
# range over the rounds, and its change against the base (the first build named).
#   kstat-summary.py DIRECTORY BASE BUILD...
import collections, glob, os, re, sys
values = collections.defaultdict(list)
controls = ["syntax", "preprocess", "tiny", "tinyfirst", "hello"]
for path in glob.glob(os.path.join(sys.argv[1], "*.csv")):
    m = re.match(r"(.+)-(%s)-(\d+)\.csv$" % "|".join(controls), os.path.basename(path))
    if not m:
        continue
    for line in open(path):
        p = line.strip().split(",")
        if len(p) > 3 and p[0] and p[0][0].isdigit():
            values[(m.group(1), m.group(2), p[2])].append(float(p[0]))
builds = sys.argv[2:] + [sys.argv[2] + "-again"]
events = ["task-clock", "page-faults", "cycles:u", "cycles:k", "iTLB-load-misses"]
for control in controls:
    print(control)
    for event in events:
        row = []
        base = values.get((builds[0], control, event))
        for build in builds:
            v = values.get((build, control, event))
            if v:
                mean = sum(v) / len(v)
                change = "" if build == builds[0] or not base else " (%+.2f%%)" % (100 * (mean / (sum(base) / len(base)) - 1))
                row.append("%s %.4g [%.4g..%.4g]%s" % (build, mean, min(v), max(v), change))
        print("  %-17s %s" % (event, "; ".join(row)))
