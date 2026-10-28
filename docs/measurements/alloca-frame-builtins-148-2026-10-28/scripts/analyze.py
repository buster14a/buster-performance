#!/usr/bin/env python3
# Paired rounds of measure.sh's perf stat lines: per tree the medians, and per round head against base.
import statistics
import sys

values = {}
for line in open(sys.argv[1]):
    if not line.startswith("round "):
        continue
    head, rest = line.split(",", 1)
    _, round_text, tree = head.split()
    fields = rest.split(",")
    event = fields[2]
    values.setdefault((int(round_text), tree), {})[event] = float(fields[0])
trees = sorted({tree for _, tree in values})
base, other = ("base", [t for t in trees if t != "base"][0])
rounds = sorted({r for r, _ in values})
for event in ("instructions:u", "cycles:u", "task-clock"):
    medians = {t: statistics.median(values[(r, t)][event] for r in rounds) for t in trees}
    deltas = [100.0 * (values[(r, other)][event] / values[(r, base)][event] - 1.0) for r in rounds]
    print(f"{event}: base median {medians[base]:.6g}, {other} median {medians[other]:.6g}; "
          f"{other} against base per round: " + " ".join(f"{d:+.3f}%" for d in deltas) +
          f"; median {statistics.median(deltas):+.3f}%")
    if event == "instructions:u":
        print(f"  instructions: {other} - base = {medians[other] - medians[base]:+.0f} (medians)")
