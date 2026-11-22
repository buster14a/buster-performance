#!/usr/bin/env python3
# keep-reduce.py DIR: the machine with no node of the walk's with its first, timed run keeping what a compile's one run
# would keep of each root (BUSTER_EXPERIMENT_ALONE_KEEP, scripts/experiment-alone-keep.patch) and without, the same binary
# in turn: medians over the runs.
import glob, re, statistics, sys
TICK = 3792.9e3
d = sys.argv[1]
out = {}
for mode in ('plain', 'kept'):
    rows = []
    for f in sorted(glob.glob(f'{d}/sqlite-{mode}-[0-9].txt')):
        t = open(f).read()
        m = re.search(r"alone bodies=\d+ left=\d+ postorder-positions=(\d+) records=(\d+) roots=(\d+) taken=(\d+) ticks: its-reading=(\d+) \(the compaction and the entries (\d+), the front (\d+), its graph's writing (\d+)\) the-machine's-first-run=(\d+)", t)
        s = re.search(r"by sweep: T=(\d+) the-tests=(\d+) C=(\d+) X=(\d+) \((\d+) of the clock's reads among them\) the-rest-of-the-run=(\d+)", t)
        rows.append([int(m.group(i)) for i in range(1, 10)] + [int(s.group(i)) for i in range(1, 7)])
    med = lambda i: statistics.median(r[i] for r in rows)
    out[mode] = [med(i) for i in range(15)]
    print(f"{mode}: {len(rows)} runs; positions {med(0):.0f}, roots {med(2):.0f}, taken {med(3):.0f}; reading {med(4)/TICK:.2f} ms; the machine's first run {med(8)/TICK:.2f} ms "
          f"(T {med(9)/TICK:.2f}, the tests {med(10)/TICK:.2f}, C {med(11)/TICK:.2f}, X {med(12)/TICK:.2f}, the rest of the run {med(14)/TICK:.2f}); "
          f"ticks a position {(med(4)+med(8))/med(0):.1f}, the machine's {med(8)/med(0):.1f}")
p, k = out['plain'], out['kept']
print(f"kept less plain: the machine's first run {(k[8]-p[8])/TICK:+.2f} ms, {(k[8]-p[8])/p[0]:+.1f} ticks a position, {(k[8]-p[8])/p[2]:+.0f} ticks a root; "
      f"T {(k[9]-p[9])/TICK:+.2f}, the tests {(k[10]-p[10])/TICK:+.2f}, C {(k[11]-p[11])/TICK:+.2f}, X {(k[12]-p[12])/TICK:+.2f}, the rest of the run {(k[14]-p[14])/TICK:+.2f}; reading {(k[4]-p[4])/TICK:+.2f}")
