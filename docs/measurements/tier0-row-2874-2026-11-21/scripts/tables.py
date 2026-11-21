#!/usr/bin/env python3
# The record's tables, from its raw results: python3 scripts/tables.py results
# Core cycles are TSC ticks times CORE_GHZ / TSC_GHZ (the 9700X's TSC is 3,792.8 MHz; the compile runs at about 5.45 GHz).
import sys, glob, statistics, math
root = sys.argv[1]
TSC_MHZ = 3792.8
CORE_GHZ = 5.45
SCALE = CORE_GHZ * 1000.0 / TSC_MHZ

def stages(directory):
    rows = {}
    proc = {}
    for path in sorted(glob.glob(directory + '/stages-*.txt')):
        for line in open(path):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'time-stage' and p[1] != 'stage':
                rows.setdefault(p[1], []).append(float(p[2]))
            if p[0] == 'time-process':
                proc.setdefault(p[1], []).append(p[2])
    return {k: statistics.median(v) for k, v in rows.items()}, proc

med, proc = stages(root + '/main')
tokens = int(proc['tokens'][0])
row = ['tier0', 'emit-setup', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'publish-data', 'object-build', 'object-write']
print('## Stage clock: -c sqlite3.c, main, medians of %d runs, %d tokens' % (len(glob.glob(root + '/main/stages-*.txt')), tokens))
print('| stage | ms | cycles a token at %.2f GHz |' % CORE_GHZ)
print('| --- | ---: | ---: |')
for k in row + ['lower.validate']:
    print('| `%s` | %.3f | %.1f |' % (k, med[k], med[k] * 1e-3 * CORE_GHZ * 1e9 / tokens))
s = sum(med[k] for k in row)
print('| **the row** | **%.3f** | **%.1f** |' % (s, s * 1e-3 * CORE_GHZ * 1e9 / tokens))
print('| the compile | %.3f | %.1f |' % (med['total'], med['total'] * 1e-3 * CORE_GHZ * 1e9 / tokens))
print()

def load(directory):
    runs = []
    for path in sorted(glob.glob(directory + '/rowlog-*.tsv')):
        rows = {}
        for line in open(path):
            p = line.split('\t')
            if len(p) >= 12:
                rows[int(p[0])] = [int(x) for x in p]
        runs.append(rows)
    bodies = sorted(set.intersection(*[set(r) for r in runs]))
    return runs, bodies

def fit(xs, ys):
    mx = sum(xs) / len(xs)
    my = sum(ys) / len(ys)
    sxx = sum((x - mx) ** 2 for x in xs)
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx
    return my - b * mx, b

runs, bodies = load(root + '/rowlog2')
n = len(runs)
data = []
for b in bodies:
    base = runs[0][b]
    parts = [statistics.median(r[b][6 + k] for r in runs) * SCALE for k in range(6)]
    passes = [statistics.median(r[b][12 + k] for r in runs) * SCALE for k in range(16)] if len(base) >= 28 else [0] * 16
    data.append((base[1], base[2], base[3], base[4], base[5], parts, passes))
E = sum(d[0] for d in data)
print('## A body at a time: %d bodies, %d typed entries, %d records, %d branches, %d references, %d bytes; medians of %d runs a body' %
      (len(data), E, sum(d[1] for d in data), sum(d[2] for d in data), sum(d[3] for d in data), sum(d[4] for d in data), n))
print('Cycles = a + b entries, least squares over the bodies but the first (its cold start).')
print()
print('| part | cycles an entry | a: cycles a body | b: cycles an entry | the bodies\' a, share |')
print('| --- | ---: | ---: | ---: | ---: |')
names = ['Tier 0 (`tier0_compile`, `emitted_from_tier0`)', 'branch sizing', 'the encoder', '`-g`\'s rows', 'the unwind rows', 'the rest of the body\'s emission']
xs = [d[0] for d in data]
total = 0
for k, name in enumerate(names):
    ys = [d[5][k] for d in data]
    a, b = fit(xs[1:], ys[1:])
    t = sum(ys)
    total += t
    print('| %s | %.1f | %.0f | %.2f | %.1f%% |' % (name, t / E, a, b, 100 * a * (len(data) - 1) / max(sum(ys[1:]), 1)))
print('| **all** | **%.1f** | | | |' % (total / E))
print()
print('By the body\'s typed entries, the median cycles an entry:')
print()
print('| entries | bodies | Tier 0 | branch sizing | the encoder | the unwind rows | all |')
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: |')
buckets = {}
for d in data[1:]:
    k = 0 if d[0] < 1 else int(math.log2(d[0]))
    buckets.setdefault(k, []).append(d)
for k in sorted(buckets):
    ds = buckets[k]
    def m(i):
        return statistics.median(d[5][i] / max(d[0], 1) for d in ds)
    alls = statistics.median(sum(d[5]) / max(d[0], 1) for d in ds)
    print('| %d to %d | %d | %.1f | %.1f | %.1f | %.1f | %.1f |' % (2 ** k, 2 ** (k + 1) - 1, len(ds), m(0), m(1), m(2), m(4), alls))
print()
passes = [(0, 'the columns\' room'), (1, 'the labels'), (2, 'the values\' predicates (P0)'), (3, 'fusion (P1 to P3)'), (4, 'the depths (P4)'),
          (5, 'selection (the words, the frame\'s alignment)'), (6, 'the homes and the frame'), (7, 'measuring and the output\'s room'),
          (8, 'emission (`tier0_emit_vector`)'), (9, 'the immediates\' forms'), (10, 'the rest of `tier0_generate`'), (11, 'labels\' and tails\' records, the close'),
          (15, '`emitted_from_tier0`')]
big = [d for d in data[1:] if d[0] >= 256]
EB = sum(d[0] for d in big)
print('## Tier 0 by pass (`rowlog2`)')
print()
print('| pass | cycles an entry | a: cycles a body | b: cycles an entry | bodies of 256 entries or more: cycles an entry |')
print('| --- | ---: | ---: | ---: | ---: |')
tt = 0
tb = 0
for k, name in passes:
    ys = [d[6][k] for d in data]
    a, b = fit(xs[1:], ys[1:])
    t = sum(ys)
    tt += t
    bb = sum(d[6][k] for d in big)
    tb += bb
    print('| %s | %.1f | %.0f | %.2f | %.1f |' % (name, t / E, a, b, bb / EB))
print('| **Tier 0** | **%.1f** | | | **%.1f** |' % (tt / E, tb / EB))
print()
print('Bodies of 256 entries or more: %d, with %d entries.' % (len(big), EB))
