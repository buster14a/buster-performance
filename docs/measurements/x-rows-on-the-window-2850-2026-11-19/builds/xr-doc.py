#!/usr/bin/env python3
# xr-doc.py RESULTS/LABEL: job-xr.sh's readings as the docs' tables' rows (markdown): the rows' counts, their ticks a
# record swept (the median of the on runs and the range), each part, the second run, and each other part's reading's
# own difference, on less off.
import re, statistics, sys, glob
results = sys.argv[1]
TESTS = r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\)"
CONTEXTS = r"window contexts ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
KERNEL = r"the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=\d+ ticks=\d+ \(([\d.]+) a record\)"
ROWS = r"window rows ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\) the rows=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\); the reference's X on the taken expressions=\d+ \(([\d.]+) a record of theirs\)"
LATER = r"window rows a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\) the rows=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
COUNTS = r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+) records-swept=(\d+) entries-written=(\d+)"
DECIDED = r"window contexts expressions=(\d+) records=(\d+) decided=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) of-them-refused=(\d+) differences=(\d+)"
LISTED = r"reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)"
READ = r"a target's word=(\d+) \(([\d.]+)% of the records swept\) a line or a table=(\d+) \(([\d.]+)%\)"
def read(path, pattern):
    m = re.search(pattern, open(path, errors='replace').read())
    return [float(x) for x in m.groups()] if m else None
corpora = ('sqlite3', 'lua', 'musl')
data = {}
for corpus in corpora:
    readings = []
    n = 1
    while True:
        paths = ['%s/rows-%s-%s-%d.txt' % (results, tag, corpus, n) for tag in ('on1', 'off1', 'off2', 'on2')]
        if not all(glob.glob(p) for p in paths):
            break
        readings.append(paths)
        n += 1
    d = {'n': len(readings)}
    first = readings[0][0]
    d['counts'] = read(first, COUNTS); d['decided'] = read(first, DECIDED); d['listed'] = read(first, LISTED); d['read'] = read(first, READ)
    on = [v for paths in readings for v in (read(paths[0], ROWS), read(paths[3], ROWS)) if v]
    later = [v for paths in readings for v in (read(paths[0], LATER), read(paths[3], LATER)) if v]
    d['rows'] = [(statistics.median(v[i] for v in on), min(v[i] for v in on), max(v[i] for v in on)) for i in range(7)]
    d['later'] = [(statistics.median(v[i] for v in later), min(v[i] for v in later), max(v[i] for v in later)) for i in range(6)]
    d['same'] = all(read(p, COUNTS) == d['counts'] for paths in readings for p in (paths[0], paths[3]))
    d['status'] = sum(1 for paths in readings for p in paths if 'status 0' in open(p, errors='replace').read())
    others = {}
    for name, pattern, columns in (('kernel', KERNEL, 1), ('tests', TESTS, 5), ('contexts', CONTEXTS, 5)):
        rows = [[read(p, pattern) for p in paths] for paths in readings]
        rows = [r for r in rows if all(r)]
        others[name] = []
        for i in range(columns):
            diffs = [(r[0][i] + r[3][i]) / 2 - (r[1][i] + r[2][i]) / 2 for r in rows]
            onv = statistics.median((r[0][i] + r[3][i]) / 2 for r in rows); offv = statistics.median((r[1][i] + r[2][i]) / 2 for r in rows)
            others[name].append((statistics.median(diffs), min(diffs), max(diffs), onv, offv))
    d['others'] = others
    data[corpus] = d
def row(label, f):
    print('| %s | %s |' % (label, ' | '.join(f(data[c]) for c in corpora)))
print('readings:', {c: data[c]['n'] for c in corpora}, 'runs with status 0:', {c: data[c]['status'] for c in corpora}, 'counts the same in every on run:', {c: data[c]['same'] for c in corpora})
row('expressions C decides on the window', lambda d: '{:,}'.format(int(d['decided'][2])))
row('expressions C takes there', lambda d: '{:,}'.format(int(d['counts'][0])))
row('their tapes made here', lambda d: '{:,} ({:.2f}%)'.format(int(d['counts'][2]), d['counts'][3]))
row('of the expressions C decides', lambda d: '{:.2f}%'.format(100.0 * d['counts'][2] / d['decided'][2]))
row('their entries', lambda d: '{:,}'.format(int(d['counts'][6])))
row('listed for an update', lambda d: '{:,}'.format(int(d['listed'][0])))
row('listed for branches', lambda d: '{:,}'.format(int(d['listed'][1])))
row('listed for a refused conversion', lambda d: '{:,}'.format(int(d['listed'][2])))
row('listed for a constant to a floating class', lambda d: '{:,}'.format(int(d['listed'][3])))
row('tapes that differ from X\'s on T\'s columns', lambda d: '{:,}'.format(int(d['counts'][7])))
row('**the three sweeps and the part, a record swept**', lambda d: '**{:.2f} ({:.2f} to {:.2f})**'.format(*d['rows'][0]))
for i, name in ((2, 'the reads'), (3, 'the shapes'), (4, 'the rows'), (5, "an expression's part")):
    row(name, lambda d, i=i: '{:.2f}'.format(d['rows'][i][0]))
row('a second run over the same chunk', lambda d: '{:.2f}'.format(d['later'][0][0]))
row('its parts: the reads, the shapes, the rows, the part', lambda d: ', '.join('{:.2f}'.format(d['later'][i][0]) for i in (2, 3, 4, 5)))
row('a record of the taken expressions', lambda d: '{:.2f}'.format(d['rows'][1][0]))
row("X on T's columns, a record of theirs, with its values", lambda d: '{:.2f}'.format(d['rows'][6][0]))
row("records whose target's word is read", lambda d: '{:,} ({:.2f}%)'.format(int(d['read'][0]), d['read'][1]))
row('records whose line is read', lambda d: '{:,} ({:.2f}%)'.format(int(d['read'][2]), d['read'][3]))
row('records swept', lambda d: '{:,}'.format(int(d['counts'][10])))
print()
print('on less off, each reading\'s own difference (median, range):')
row('the kernel in place', lambda d: '{:+.2f} ({:+.2f} to {:+.2f})'.format(*d['others']['kernel'][0][:3]))
for i, name in ((0, "the tests on the window, their sum"), (1, "the records' bytes"), (2, "the tests' loop"), (3, "the tests' expression's part"), (4, "the tests on T's records")):
    row(name, lambda d, i=i: '{:+.2f} ({:+.2f} to {:+.2f})'.format(*d['others']['tests'][i][:3]))
for i, name in ((0, "C's three sweeps, a record swept"), (2, "C's loop"), (3, "C's targets"), (4, "C's expression's part")):
    row(name, lambda d, i=i: '{:+.2f} ({:+.2f} to {:+.2f})'.format(*d['others']['contexts'][i][:3]))
