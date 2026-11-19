#!/usr/bin/env python3
# gat-table.py RESULTS BASE_LABEL HEAD_LABEL: job-gat.sh's readings: the tests on the window's ticks a record (their sum and the
# records' bytes' part) and C's sweeps', for the base and the head in turn; medians of the readings, and each
# reading's own difference (head less base): its median and range.
import re, statistics, sys, glob
results, base, head = sys.argv[1:4]
def read(path, pattern):
    t = open(path, errors='replace').read()
    m = re.search(pattern, t)
    return [float(x) for x in m.groups()] if m else None
TESTS = r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\)"
CONTEXTS = r"window contexts ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\)"
for corpus in ('sqlite3', 'lua', 'musl'):
    for name, pattern, base_tag, head_tag, columns in (
            ('tests', TESTS, 'vs-%s' % head, 'window-tests', ('sum', 'bytes', 'loop', "expression's part", "tests on T's")),
            ('C', CONTEXTS, 'contexts-vs-%s' % head, 'window-contexts', ('a record swept', 'a record of the decided', 'loop', 'targets'))):
        rows = []
        n = 1
        while True:
            b = glob.glob('%s/%s/%s-%s-%d.txt' % (results, base, base_tag, corpus, n))
            h = glob.glob('%s/%s/%s-%s-%d.txt' % (results, head, head_tag, corpus, n))
            if not b or not h:
                break
            rb, rh = read(b[0], pattern), read(h[0], pattern)
            if rb and rh:
                rows.append((rb, rh))
            n += 1
        if not rows:
            continue
        print('%s %s (%d readings)' % (corpus, name, len(rows)))
        for i, column in enumerate(columns):
            bs = [r[0][i] for r in rows]; hs = [r[1][i] for r in rows]; ds = [r[1][i] - r[0][i] for r in rows]
            print('   %-24s base %6.2f  head %6.2f  head less base %+6.2f (%+.2f to %+.2f)' % (column, statistics.median(bs), statistics.median(hs), statistics.median(ds), min(ds), max(ds)))
