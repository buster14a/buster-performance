#!/usr/bin/env python3
# Summarizes ab's rounds of benchmark-lowering-source: per tree, the median across rounds of referenced_ns (the
# lowering of the definitions -c lowers) against the base tree's, then each round's against the base's in the same
# round. Usage: summarize-lowering.py LOG BASE.
import re, statistics, sys
rows = []
tree = None
round_number = None
for line in open(sys.argv[1]):
    m = re.match(r"== round (\d+) tree \./(\w+)", line)
    if m:
        round_number, tree = int(m.group(1)), m.group(2)
        continue
    m = re.match(r"lowering-source: totals .* referenced_ns=(\d+) all_ns=(\d+)", line)
    if m:
        rows.append((round_number, tree, int(m.group(1))))
base = sys.argv[2]
trees = [base] + sorted({r[1] for r in rows} - {base}, key=lambda t: [r[1] for r in rows].index(t))
reference = None
for t in trees:
    r = [x[2] for x in rows if x[1] == t]
    median = statistics.median(r)
    line = f"{t} rounds={len(r)} referenced {median / 1e6:.3f} ms (rounds {min(r) / 1e6:.3f} to {max(r) / 1e6:.3f})"
    if reference is None:
        reference = median
    else:
        line += f" | {100 * (median / reference - 1):+.2f}%"
    print(line)
for t in trees[1:]:
    deltas = []
    for n in sorted({x[0] for x in rows}):
        a = [x[2] for x in rows if x[0] == n and x[1] == base]
        b = [x[2] for x in rows if x[0] == n and x[1] == t]
        deltas.append(100 * (b[0] / a[0] - 1))
    print(f"{t} against {base}, round by round: " + ", ".join(f"{d:+.2f}%" for d in deltas))
