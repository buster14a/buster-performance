#!/usr/bin/env python3
# first-reduce.py DIR: the machine with no node of the walk's with every body read before the walk's first chunk
# (--front-alone-first) against each body read before the walk acts at it (--front-alone): medians over the runs of the
# piece's ticks, whole and by a lowered body's verdict.
import glob, re, statistics, sys
d = sys.argv[1]
TICK = 3792.9e3
for name in ('sqlite', 'lua'):
    for option in ('front-alone', 'front-alone-first'):
        runs = []
        for f in sorted(glob.glob(f'{d}/{name}-{option}-[0-9].txt')):
            t = open(f).read()
            tot = [0, 0, 0, 0, 0, 0]
            for m in re.finditer(r"alone bodies=\d+ left=\d+ postorder-positions=(\d+) records=(\d+) roots=\d+ taken=\d+ ticks: its-reading=(\d+) \(the compaction and the entries (\d+), the front (\d+), its graph.s writing (\d+)\) the-machine.s-first-run=(\d+)", t):
                for i, k in enumerate((1, 3, 4, 5, 6, 7)):
                    tot[i] += int(m.group(k))
            verdicts = {}
            for v, bodies, tokens, reading, machine in re.findall(r"alone verdict=(\S+) bodies=(\d+) tokens=(\d+) ticks: reading=(\d+) the-machine.s-first-run=(\d+)", t):
                e = verdicts.setdefault(v, [0, 0, 0, 0])
                for i, x in enumerate((bodies, tokens, reading, machine)):
                    e[i] += int(x)
            runs.append((tot, verdicts))
        med = lambda i: statistics.median(r[0][i] for r in runs)
        print(f"{name} --{option}: {len(runs)} runs; positions {med(0):.0f}; reading {med(1) / TICK:.2f} ms (compaction and entries {med(2) / TICK:.2f}, front {med(3) / TICK:.2f}, writing {med(4) / TICK:.2f}); machine {med(5) / TICK:.2f} ms; ticks a position {(med(1) + med(5)) / med(0):.1f}")
        swept_tokens = 0; swept_ticks = 0
        for v in runs[0][1]:
            col = lambda i: statistics.median(r[1][v][i] for r in runs)
            print(f"    verdict {v}: bodies {col(0):.0f} tokens {col(1):.0f} reading {col(2) / TICK:.2f} ms machine {col(3) / TICK:.2f} ms; ticks a token {(col(2) + col(3)) / col(1):.1f}")
            if v != 'a-token-left':
                swept_tokens += col(1); swept_ticks += col(2) + col(3)
        print(f"    swept after the scan (every verdict but a root the front lost): tokens {swept_tokens:.0f}, {swept_ticks / TICK:.2f} ms, ticks a token {swept_ticks / swept_tokens:.1f}, ns a token {swept_ticks / swept_tokens / 3.7929:.1f}")
