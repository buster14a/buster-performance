#!/usr/bin/env python3
# #1444: kstat.sh's perf stat files summarized: for each control and build, the median over rounds of each event's
# mean over its runs, and each build against base, with base-again's as the floor.
#   kstat-summary.py DIRECTORY
import collections
import glob
import os
import re
import statistics
import sys

values = collections.defaultdict(list)
for path in sorted(glob.glob(os.path.join(sys.argv[1], "*.csv"))):
    # kstat.sh's BUILD-CONTROL-ROUND.csv, or kstat2.sh's BUILD-CONTROL-PLACEMENT-ROUND.csv: each placement and round one
    # value, and the median over them all.
    m = re.match(r'(.+?)-(syntax|preprocess|tiny-lanes|sqlite-lanes|tiny|hello|medium)-(\d+)(?:-(\d+))?\.csv$', os.path.basename(path))
    if not m:
        continue
    build, control = m.group(1), m.group(2)
    for line in open(path):
        p = line.strip().split(",")
        if len(p) < 3 or line.startswith("#") or not p[0] or p[0].startswith("<"):
            continue
        values[(control, build, p[2])].append(float(p[0]))
events = ["task-clock", "page-faults", "cycles:u", "cycles:k", "instructions:u", "instructions:k"]
controls = ["syntax", "preprocess", "tiny", "hello", "medium", "tiny-lanes", "sqlite-lanes"]
builds = sorted({k[1] for k in values}, key=lambda b: (b != "base", b == "base-again", b))
for control in controls:
    print("%s:" % control)
    for event in events:
        base = values.get((control, "base", event))
        if not base:
            continue
        row = []
        for build in builds:
            v = values.get((control, build, event))
            if not v:
                continue
            median = statistics.median(v)
            text = "%s %.4g" % (build, median)
            if build != "base":
                text += " (%+.2f%%)" % (100 * (median / statistics.median(base) - 1))
            row.append(text)
        print("  %-15s %s" % (event, "; ".join(row)))
