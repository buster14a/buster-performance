#!/usr/bin/env python3
# #1444: faults.sh's attributions summarized: each control's faults a process by region and, for the anonymous ones, by
# mapping (named for the code that made it), for each build, as the median over its four placements.
#   faults-summary.py DIRECTORY RUNS
import collections
import glob
import os
import re
import statistics
import sys

runs = float(sys.argv[2])
regions = collections.defaultdict(lambda: collections.defaultdict(list))
mappings = collections.defaultdict(lambda: collections.defaultdict(list))
for path in sorted(glob.glob(os.path.join(sys.argv[1], "attribution-*.txt"))):
    m = re.match(r'attribution-(.+)-(\d+)-(\w+)\.txt$', os.path.basename(path))
    build, placement, control = m.groups()
    section = None
    seen_regions = collections.Counter()
    seen_mappings = collections.Counter()
    for line in open(path):
        if line.startswith("faults: "):
            seen_regions["total"] = int(line.split()[1])
            section = "regions"
            continue
        if line.startswith("faults by mapping"):
            section = "mappings"
            continue
        p = line.split()
        if section == "regions" and len(p) >= 2 and p[0].isdigit():
            name = " ".join(p[1:])
            name = "file-backed" if name.startswith(".") else name
            seen_regions[name] += int(p[0])
        elif section == "mappings" and len(p) >= 3 and p[0].isdigit():
            label = re.sub(r'\s+\S+ \d+/\d+.*$', '', line[12:].rstrip())
            label = re.sub(r'\s{2,}.*$', '', label)
            seen_mappings[label] += int(p[0])
    for k, v in seen_regions.items():
        regions[(control, k)][build].append(v / runs)
    for k, v in seen_mappings.items():
        mappings[(control, k)][build].append(v / runs)
builds = sorted({b for v in regions.values() for b in v}, key=lambda b: (b != "base", b))
for control in ["syntax", "preprocess", "tiny", "hello"]:
    print("%s, faults a process (median of the placements; their range):" % control)
    keys = sorted({k for (c, k) in regions if c == control}, key=lambda k: (k != "total", -statistics.median(regions[(control, k)].get("base", [0]))))
    for k in keys:
        row = []
        for b in builds:
            v = regions[(control, k)].get(b, [0])
            row.append("%s %.1f (%.1f to %.1f)" % (b, statistics.median(v), min(v), max(v)))
        print("  %-22s %s" % (k, "; ".join(row)))
    print("  anonymous, by mapping:")
    keys = sorted({k for (c, k) in mappings if c == control}, key=lambda k: -max(statistics.median(mappings[(control, k)].get(b, [0])) for b in builds))
    for k in keys[:12]:
        row = ["%s %.1f" % (b, statistics.median(mappings[(control, k)].get(b, [0]))) for b in builds]
        print("    %-62s %s" % (k[:62], "; ".join(row)))
