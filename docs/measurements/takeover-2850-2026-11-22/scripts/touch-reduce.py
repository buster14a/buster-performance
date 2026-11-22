#!/usr/bin/env python3
# touch-reduce.py DIR: the piece's ticks with its own memory touched before any timed run (BUSTER_EXPERIMENT_ALONE_TOUCH,
# scripts/experiment-alone-touch.patch) and without, the same binary in turn: medians over the runs.
import glob, re, statistics, sys
TICK = 3792.9e3
d = sys.argv[1]
for mode in ('plain', 'touched'):
    rows = []
    for f in sorted(glob.glob(f'{d}/sqlite-{mode}-[0-9].txt')):
        t = open(f).read()
        m = re.search(r"alone bodies=\d+ left=\d+ postorder-positions=(\d+) records=(\d+) roots=\d+ taken=\d+ ticks: its-reading=(\d+) \(the compaction and the entries (\d+), the front (\d+), its graph.s writing (\d+)\) the-machine.s-first-run=(\d+)", t)
        s = re.search(r"by sweep: T=(\d+) the-tests=(\d+) C=(\d+) X=(\d+)", t)
        e = re.search(r"experiment-alone-touch: (\d+) pages of 4 KB \((\d+) MB of the scratch arena, (\d+) MB of the reader's\)", t)
        rows.append([int(m.group(i)) for i in (1, 3, 4, 5, 6, 7)] + [int(s.group(i)) for i in (1, 2, 3, 4)] + ([int(e.group(i)) for i in (1, 2, 3)] if e else [0, 0, 0]))
    med = lambda i: statistics.median(r[i] for r in rows)
    print(f"{mode}: {len(rows)} runs; reading {med(1)/TICK:.2f} ms (the compaction and the entries {med(2)/TICK:.2f}, the front {med(3)/TICK:.2f}, the graph's writing {med(4)/TICK:.2f}); "
          f"the machine's first run {med(5)/TICK:.2f} (T {med(6)/TICK:.2f}, the tests {med(7)/TICK:.2f}, C {med(8)/TICK:.2f}, X {med(9)/TICK:.2f}); ticks a position {(med(1)+med(5))/med(0):.1f}; "
          f"pages touched first {med(10):.0f} ({med(11):.0f} MB of the scratch arena's reservation, {med(12):.0f} of the reader's)")
