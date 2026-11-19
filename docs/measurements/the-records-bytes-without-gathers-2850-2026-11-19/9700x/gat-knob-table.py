#!/usr/bin/env python3
# gat-knob-table.py RESULTS/LABEL: job-gat-knob.sh's readings of one executable, the sweep's columns by loads and
# permutes (on) and by the four gathers (off), on, off, off, on in each reading: each reading's own difference, on less
# off (the mean of its two on runs less the mean of its two off runs): the median over the readings and the range.
import re, statistics, sys, glob
results = sys.argv[1]
TESTS = r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\)"
CONTEXTS = r"window contexts ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\)"
def read(path, pattern):
    m = re.search(pattern, open(path, errors='replace').read())
    return [float(x) for x in m.groups()] if m else None
bad = [p for p in glob.glob(results + '/*-*-*.txt') if 'status 0' not in open(p, errors='replace').read()]
print('runs without status 0: %d' % len(bad))
for corpus in ('sqlite3', 'lua', 'musl'):
    for mode, pattern, columns in (('tests', TESTS, ('the tests on the window, a record', "the records' bytes", 'the loop', "an expression's part", "the tests on T's records")),
                                   ('contexts', TESTS, ('(with C) the tests on the window, a record', "(with C) the records' bytes", '(with C) the loop', "(with C) an expression's part", "(with C) the tests on T's records")),
                                   ('contexts', CONTEXTS, ("C's sweeps, a record swept", 'a record of the decided', "C's loop", 'the targets'))):
        rows = []
        n = 1
        while True:
            paths = ['%s/%s-%s-%s-%d.txt' % (results, mode, tag, corpus, n) for tag in ('on1', 'off1', 'off2', 'on2')]
            if not all(glob.glob(p) for p in paths):
                break
            values = [read(p, pattern) for p in paths]
            if all(values):
                rows.append(values)
            n += 1
        if not rows:
            continue
        for i, column in enumerate(columns):
            on = [(r[0][i] + r[3][i]) / 2 for r in rows]; off = [(r[1][i] + r[2][i]) / 2 for r in rows]
            d = [a - b for a, b in zip(on, off)]
            print('%-8s %-46s on %6.2f  off %6.2f  on less off %+6.2f (%+.2f to %+.2f)  [%d readings]' % (corpus, column, statistics.median(on), statistics.median(off), statistics.median(d), min(d), max(d), len(rows)))
