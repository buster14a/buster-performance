#!/usr/bin/env python3
# xu-table.py RESULTS LABEL: job-xu.sh's readings: one executable (RESULTS/LABEL) with the update's rows on and off
# (the experiment's switch), on, off, off, on in each reading, and the piece before's executable twice between
# (RESULTS/xr10/LABEL-base1 and -base2). The rows' own ticks a record swept in each of the three (the median of its
# runs, and the range), their counts, and for every part each reading's own difference: on less off, and on less the
# piece before's.
import re, statistics, sys, glob
results, label = sys.argv[1], sys.argv[2]
TESTS = r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\)"
CONTEXTS = r"window contexts ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
KERNEL = r"the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=\d+ ticks=\d+ \(([\d.]+) a record\)"
ROWS = r"window rows ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\)(?: the updates=\d+ \(([\d.]+)\))? the rows=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\); the reference's X on the taken expressions=\d+ \(([\d.]+) a record of theirs\)"
LATER = r"window rows a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\)(?: the updates=\d+ \(([\d.]+)\))? the rows=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
COUNTS = r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+) records-swept=(\d+) entries-written=(\d+)"
LISTED = r"window rows listed, by an expression's first record's reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)"
READ = r"a target's word=(\d+) \([\d.]+% of the records swept\) a line or a table=(\d+) \([\d.]+%\)(?: an update's (?:plan|line|computation's class)=(\d+))?"
def read(path, pattern):
    m = re.search(pattern, open(path, errors='replace').read())
    return [float(x) if x is not None else 0.0 for x in m.groups()] if m else None
def paths(corpus, n):
    return ['%s/%s/rows-on1-%s-%d.txt' % (results, label, corpus, n), '%s/%s/rows-off1-%s-%d.txt' % (results, label, corpus, n),
            '%s/xr10/%s-base1-%s-%d.txt' % (results, label, corpus, n), '%s/xr10/%s-base2-%s-%d.txt' % (results, label, corpus, n),
            '%s/%s/rows-off2-%s-%d.txt' % (results, label, corpus, n), '%s/%s/rows-on2-%s-%d.txt' % (results, label, corpus, n)]
every = glob.glob('%s/%s/rows-*-*-*.txt' % (results, label)) + glob.glob('%s/xr10/%s-base*-*-*.txt' % (results, label))
print('runs: %d; without status 0: %d' % (len(every), len([p for p in every if 'status 0' not in open(p, errors='replace').read()])))
for corpus in ('sqlite3', 'lua', 'musl'):
    readings = []
    n = 1
    while all(glob.glob(p) for p in paths(corpus, n)):
        readings.append(paths(corpus, n))
        n += 1
    if not readings:
        continue
    for name, index in (('on', 0), ('off', 1), ('before', 2)):
        c = read(readings[0][index], COUNTS); l = read(readings[0][index], LISTED); r = read(readings[0][index], READ)
        same = all(read(p[i], COUNTS) == c for p in readings for i in ((0, 5) if index == 0 else (1, 4) if index == 1 else (2, 3)))
        print('%-8s %-7s expressions %d taken %d (%.2f%%) entries %d differences %d swept %d written %d; listed %d %d %d %d; words %d lines %d updates %d; the same in every run: %s  [%d readings]' % (
            corpus, name, c[0], c[2], c[3], c[6], c[7], c[10], c[11], l[0], l[1], l[2], l[3], r[0], r[1], r[2], same, len(readings)))
    for pattern, columns in ((ROWS, ("the rows' sweeps, a record swept", 'a record of the taken', 'the reads', 'the shapes', 'the updates', 'the rows', "an expression's part", "the reference's X, a record of the taken")),
                             (LATER, ("(a second run) a record swept", '(a second run) a record of the taken', '(a second run) the reads', '(a second run) the shapes', '(a second run) the updates', '(a second run) the rows', "(a second run) an expression's part")),
                             (KERNEL, ('the kernel in place, a record',)),
                             (TESTS, ('the tests on the window, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records")),
                             (CONTEXTS, ("C's sweeps, a record swept", 'C, a record of the decided', "C's loop", "C's targets", "C's expression's part"))):
        rows = [[read(p, pattern) for p in ps] for ps in readings]
        rows = [r for r in rows if all(r)]
        for i, column in enumerate(columns):
            on = [(r[0][i] + r[5][i]) / 2 for r in rows]; off = [(r[1][i] + r[4][i]) / 2 for r in rows]; before = [(r[2][i] + r[3][i]) / 2 for r in rows]
            d = [a - b for a, b in zip(on, off)]; e = [a - b for a, b in zip(on, before)]
            every_on = [r[k][i] for r in rows for k in (0, 5)]
            print('%-8s %-44s on %6.2f (%.2f to %.2f)  off %6.2f  before %6.2f  on less off %+5.2f (%+.2f to %+.2f)  on less before %+5.2f (%+.2f to %+.2f)' % (
                corpus, column, statistics.median(every_on), min(every_on), max(every_on), statistics.median(off), statistics.median(before),
                statistics.median(d), min(d), max(d), statistics.median(e), min(e), max(e)))
