#!/usr/bin/env python3
# Summarizes ab's rounds of time-runs: per tree and list, the median across rounds of each round's median wall time,
# user cycles and instructions, each against the base tree's; then each round's wall time against the base's in the
# same round. Usage: summarize-ab.py LOG BASE.
import re, statistics, sys
rows = []
tree = None
round_number = None
for line in open(sys.argv[1]):
    m = re.match(r"== round (\d+) tree \./(\w+)", line)
    if m:
        round_number, tree = int(m.group(1)), m.group(2)
        continue
    m = re.match(r"list \d \[(-c|-fsyntax-only).*median ([\d.]+) ms wall \(([\d.]+) to ([\d.]+)\).* (\d+) user cycles, (\d+) instructions", line)
    if m:
        rows.append((round_number, tree, m.group(1), float(m.group(2)), int(m.group(5)), int(m.group(6))))
base = sys.argv[2]
trees = [base] + sorted({r[1] for r in rows} - {base}, key=lambda t: [r[1] for r in rows].index(t))
for command in ("-c", "-fsyntax-only"):
    reference = None
    for t in trees:
        r = sorted((x for x in rows if x[1] == t and x[2] == command), key=lambda x: x[0])
        wall = statistics.median(x[3] for x in r)
        cycles = statistics.median(x[4] for x in r)
        instructions = statistics.median(x[5] for x in r)
        line = (f"{command:14} {t} rounds={len(r)} wall {wall:.3f} ms (rounds {min(x[3] for x in r):.3f} to {max(x[3] for x in r):.3f})"
                f" cycles {cycles / 1e6:.2f}M instructions {instructions:,}")
        if reference is None:
            reference = (wall, cycles, instructions)
        else:
            line += (f" | wall {100 * (wall / reference[0] - 1):+.2f}% cycles {100 * (cycles / reference[1] - 1):+.2f}%"
                     f" instructions {instructions - reference[2]:+,} ({100 * (instructions / reference[2] - 1):+.3f}%)")
        print(line)
    for t in trees[1:]:
        deltas = []
        for n in sorted({x[0] for x in rows}):
            a = [x[3] for x in rows if x[0] == n and x[1] == base and x[2] == command]
            b = [x[3] for x in rows if x[0] == n and x[1] == t and x[2] == command]
            deltas.append(100 * (b[0] / a[0] - 1))
        print(f"{command:14} {t} against {base}, round by round: " + ", ".join(f"{d:+.2f}%" for d in deltas))
