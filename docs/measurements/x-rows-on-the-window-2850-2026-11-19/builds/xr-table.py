#!/usr/bin/env python3
# xr-table.py RESULTS/LABEL: job-xr.sh's readings of one executable, X's rows on the window on (--window-rows) and off
# (--window-contexts), on, off, off, on in each reading. The rows' own ticks a record swept (the median of the on
# runs, and the range), their counts, and for each other part each reading's own difference, on less off (the mean
# of its two on runs less the mean of its two off runs): the median over the readings and the range.
import re, statistics, sys, glob
results = sys.argv[1]
TESTS = r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\)"
CONTEXTS = r"window contexts ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
KERNEL = r"the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=\d+ ticks=\d+ \(([\d.]+) a record\)"
ROWS = r"window rows ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\) the rows=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\); the reference's X on the taken expressions=\d+ \(([\d.]+) a record of theirs\)"
LATER = r"window rows a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\) the rows=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
COUNTS = r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+) records-swept=(\d+) entries-written=(\d+)"
def read(path, pattern):
    m = re.search(pattern, open(path, errors='replace').read())
    return [float(x) for x in m.groups()] if m else None
bad = [p for p in glob.glob(results + '/rows-*-*-*.txt') if 'status 0' not in open(p, errors='replace').read()]
print('runs without status 0: %d' % len(bad))
for corpus in ('sqlite3', 'lua', 'musl'):
    readings = []
    n = 1
    while True:
        paths = ['%s/rows-%s-%s-%d.txt' % (results, tag, corpus, n) for tag in ('on1', 'off1', 'off2', 'on2')]
        if not all(glob.glob(p) for p in paths):
            break
        readings.append(paths)
        n += 1
    if not readings:
        continue
    c = read(readings[0][0], COUNTS)
    print('%-8s expressions %d taken %d (%.2f%%) their records %d (%.2f%%) entries %d differences %d not kept %d records swept %d  [%d readings]' % (
        corpus, c[0], c[2], c[3], c[4], c[5], c[6], c[7], c[8], c[10], len(readings)))
    for pattern, columns in ((ROWS, ("the rows' sweeps, a record swept", 'a record of the taken', 'the reads', 'the shapes', 'the rows', "an expression's part", "the reference's X, a record of the taken")),
                             (LATER, ("(a second run) a record swept", '(a second run) a record of the taken', '(a second run) the reads', '(a second run) the shapes', '(a second run) the rows', "(a second run) an expression's part"))):
        for i, column in enumerate(columns):
            values = [v[i] for paths in readings for v in (read(paths[0], pattern), read(paths[3], pattern)) if v]
            print('%-8s %-46s %6.2f (%.2f to %.2f)' % (corpus, column, statistics.median(values), min(values), max(values)))
    for pattern, columns in ((KERNEL, ('the kernel in place, a record',)),
                             (TESTS, ('the tests on the window, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records")),
                             (CONTEXTS, ("C's sweeps, a record swept", 'C, a record of the decided', "C's loop", "C's targets", "C's expression's part"))):
        rows = [[read(p, pattern) for p in paths] for paths in readings]
        rows = [r for r in rows if all(r)]
        for i, column in enumerate(columns):
            on = [(r[0][i] + r[3][i]) / 2 for r in rows]; off = [(r[1][i] + r[2][i]) / 2 for r in rows]
            d = [a - b for a, b in zip(on, off)]
            print('%-8s %-46s on %6.2f  off %6.2f  on less off %+6.2f (%+.2f to %+.2f)' % (corpus, column, statistics.median(on), statistics.median(off), statistics.median(d), min(d), max(d)))
