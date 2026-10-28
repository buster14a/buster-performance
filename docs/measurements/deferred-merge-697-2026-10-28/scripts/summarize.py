#!/usr/bin/env python3
# Summarizes head.txt's benchmark processes: per build (a, b, c), the median and range over its processes of each
# reading's numbers, in ns/token.
import re
import statistics
import sys

text = open(sys.argv[1]).read()
blocks = re.split(r"^== \S+ (head-[abc]) env .*benchmark-checker-deferred.*$", text, flags=re.M)
# blocks: [preamble, build, body, build, body, ...]
data = {}
for i in range(1, len(blocks), 2):
    build = blocks[i][-1]
    body = blocks[i + 1]
    row = {}
    m = re.search(r"source_order=([\d.]+)", body)
    if not m:
        continue
    row["source"] = float(m.group(1))
    for lanes in ("1", "8"):
        m = re.search(r"lanes=" + lanes + r" active=\d+ copies=\d+ whole=([\d.]+) top=([\d.]+) environment=[\d.]+ walks=[\d.]+ positions=[\d.]+ lanes_span=([\d.]+) merge=([\d.]+) rest=([\d.]+)", body)
        row["whole" + lanes] = float(m.group(1))
        row["top" + lanes] = float(m.group(2))
        row["span" + lanes] = float(m.group(3))
        row["merge" + lanes] = float(m.group(4))
        row["rest" + lanes] = float(m.group(5))
        m = re.search(r"lanes=" + lanes + r" merge's parts: replay=([\d.]+) tables=([\d.]+) events=([\d.]+) tags=([\d.]+) (?:tokens|pass)=([\d.]+) rest=([\d.]+)", body)
        for k, v in zip(("replay", "tables", "events", "tags", "pass", "mrest"), m.groups()):
            row[k + lanes] = float(v)
    data.setdefault(build, []).append(row)

keys = ["source", "whole1", "whole8", "top1", "top8", "span1", "span8", "merge1", "merge8", "rest1", "rest8",
        "replay1", "replay8", "tables1", "tables8", "events1", "events8", "tags1", "tags8", "pass1", "pass8", "mrest1", "mrest8"]
for build in sorted(data):
    rows = data[build]
    print("build", build, "processes", len(rows))
    for k in keys:
        values = [r[k] for r in rows]
        print("  %-8s median %7.3f  range %7.3f to %7.3f" % (k, statistics.median(values), min(values), max(values)))
    # Each process's deferred reading against its own source order.
    for lanes in ("1", "8"):
        ratios = [r["whole" + lanes] / r["source"] - 1 for r in rows]
        print("  whole%s/source: median %+.2f%%  range %+.2f%% to %+.2f%%" % (lanes, 100 * statistics.median(ratios), 100 * min(ratios), 100 * max(ratios)))
