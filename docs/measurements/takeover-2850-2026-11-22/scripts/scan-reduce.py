#!/usr/bin/env python3
# scan-reduce.py DIR: the scan of a body's tokens in the runs of alone-split.sh: per corpus, medians over the runs of the
# scan's tokens read and ticks (summed over a run's units), and the verdicts' bodies with what the scan finds.
import glob, re, statistics, sys
d = sys.argv[1]
TICK = 3792.9e3
for name in ('sqlite', 'lua', 'musl'):
    runs = []
    for f in sorted(glob.glob(f'{d}/{name}-[0-9].txt')):
        t = open(f).read()
        scan = [(int(a), int(b)) for a, b in re.findall(r"alone a scan of every body.s tokens for a root the front would lose: tokens-read=(\d+) ticks=(\d+)", t)]
        pos = [int(a) for a in re.findall(r"alone bodies=\d+ left=\d+ postorder-positions=(\d+)", t)]
        verdicts = {}
        for v, bodies, tokens, reading, machine, sb, st in re.findall(r"alone verdict=(\S+) bodies=(\d+) tokens=(\d+) ticks: reading=(\d+) the-machine.s-first-run=(\d+) by-the-chunk-that-stops-them=\d+ a-scan-of-the-tokens-refuses: bodies=(\d+) tokens=(\d+)", t):
            e = verdicts.setdefault(v, [0, 0, 0, 0, 0, 0])
            for i, x in enumerate((bodies, tokens, reading, machine, sb, st)):
                e[i] += int(x)
        runs.append((sum(a for a, b in scan), sum(b for a, b in scan), sum(pos), verdicts))
    med = lambda i: statistics.median(r[i] for r in runs)
    print(f"{name}: {len(runs)} runs; bodies' positions {med(2):.0f}; the scan read {med(0):.0f} tokens in {med(1):.0f} ticks ({med(1) / TICK:.3f} ms), {med(1) / med(0):.2f} a token read, {med(1) / med(2):.2f} a position")
    for v in runs[0][3]:
        col = lambda i: statistics.median(r[3][v][i] for r in runs)
        print(f"  verdict {v}: bodies {col(0):.0f} tokens {col(1):.0f} reading {col(2) / TICK:.2f} ms machine {col(3) / TICK:.2f} ms; the scan finds a lost root in {col(4):.0f} bodies, {col(5):.0f} tokens")
