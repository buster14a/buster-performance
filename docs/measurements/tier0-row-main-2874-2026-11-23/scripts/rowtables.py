#!/usr/bin/env python3
# rowtables.py COLD_DIR [WARM_DIR]: the row log's tables (buster#2874). A rowlog-N.tsv line is a body: body, entries,
# records, branches, references, bytes, then TSC ticks: Tier 0, sizing, encoder, -g, unwind, rest, then Tier 0's 16 pass
# laps (with BUSTER_ROW_WARM, lap 13 is the first, cold, run's whole Tier 0). Cycles = ticks x 5.45 / 3.7928.
import glob
import math
import statistics
import sys

SCALE = 5.45 * 1000.0 / 3792.8


def load(directory):
    runs = []
    for path in sorted(glob.glob(directory + '/rowlog-*.tsv')):
        rows = {}
        for line in open(path):
            p = line.split('\t')
            if len(p) >= 28:
                rows[int(p[0])] = [int(x) for x in p]
        runs.append(rows)
    bodies = sorted(set.intersection(*[set(r) for r in runs]))
    out = []
    for b in bodies:
        base = runs[0][b]
        cols = [statistics.median(r[b][k] for r in runs) * SCALE for k in range(6, 28)]
        out.append((b, base[1], base[2], base[3], base[4], base[5], cols))
    return out


def fit(xs, ys):
    mx = sum(xs) / len(xs)
    my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs)
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx
    return my - b * mx, b


cold = load(sys.argv[1])
E = sum(d[1] for d in cold)
print('bodies %d entries %d records %d branches %d references %d bytes %d' % (len(cold), E, sum(d[2] for d in cold), sum(d[3] for d in cold), sum(d[4] for d in cold), sum(d[5] for d in cold)))
names = ['tier0', 'sizing', 'encode', 'debug', 'unwind', 'rest']
xs = [d[1] for d in cold]
print('| part | cycles an entry | a | b | total Mcycles |')
for k, name in enumerate(names):
    ys = [d[6][k] for d in cold]
    a, b = fit(xs[1:], ys[1:])
    print('| %s | %.2f | %.0f | %.2f | %.2f |' % (name, sum(ys) / E, a, b, sum(ys) / 1e6))
passes = [(0, 'room'), (1, 'labels'), (2, 'values P0'), (3, 'fusion P1-P3'), (4, 'depths P4'), (5, 'selection'), (6, 'homes, frame'), (7, 'measure, room'),
          (8, 'emission'), (9, 'forms'), (10, 'rest of generate'), (11, 'labels/tails/close'), (15, 'emitted_from_tier0')]
print('| pass | cycles an entry | a | b | total Mcycles |')
for k, name in passes:
    ys = [d[6][6 + k] for d in cold]
    a, b = fit(xs[1:], ys[1:])
    print('| %s | %.2f | %.0f | %.2f | %.2f |' % (name, sum(ys) / E, a, b, sum(ys) / 1e6))
if len(sys.argv) > 2:
    warm = {d[0]: d for d in load(sys.argv[2])}
    both = [d for d in cold if d[0] in warm]
    c = sum(d[6][0] for d in both)
    w = sum(warm[d[0]][6][0] for d in both)
    first = sum(warm[d[0]][6][6 + 13] for d in both)
    print('warm: Tier 0 cold %.2f Mcycles (%.2f an entry), its first run in the warm log %.2f, warm %.2f (%.2f an entry)' % (c / 1e6, c / E, first / 1e6, w / 1e6, w / E))
    print('| entries | bodies | cold an entry | warm an entry | cold - warm a body |')
    buckets = {}
    for d in both:
        k = 0 if d[1] < 1 else int(math.log2(d[1]))
        buckets.setdefault(k, []).append(d)
    for k in sorted(buckets):
        ds = buckets[k]
        ce = sum(d[6][0] for d in ds) / sum(d[1] for d in ds)
        we = sum(warm[d[0]][6][0] for d in ds) / sum(d[1] for d in ds)
        diff = statistics.median(d[6][0] - warm[d[0]][6][0] for d in ds)
        print('| %d-%d | %d | %.1f | %.1f | %.0f |' % (2 ** k, 2 ** (k + 1) - 1, len(ds), ce, we, diff))
    print('| pass | cold an entry | warm an entry |')
    for k, name in passes:
        cc = sum(d[6][6 + k] for d in both)
        ww = sum(warm[d[0]][6][6 + k] for d in both)
        print('| %s | %.2f | %.2f |' % (name, cc / E, ww / E))
