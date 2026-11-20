#!/usr/bin/env python3
# xl-table.py RESULTS LABEL BASE SUFFIX: job-xl.sh's readings: the piece's executable (RESULTS/LABEL) first and last in
# each reading, and the piece before's twice between (RESULTS/BASE/LABEL-base1 and -base2). For each part of C's sweeps
# and of the rows', the median of the readings and their range in each of the two, and each reading's own difference;
# the counts; and a chunk's first run less its second, in ticks a chunk.
import glob, re, statistics, sys
results, label, base, suffix = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
TESTS = r"window tests ticks=\d+ \(([\d.]+) a record\): the records' bytes=\d+ \(([\d.]+)\) the loop=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\) the tests on T's records=\d+ \(([\d.]+)\)"
CONTEXTS = r"window contexts ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\); the reference's C on the decided expressions=\d+ \(([\d.]+) a record of theirs\)"
CONTEXTS_LATER = r"window contexts a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the decided\): the loop=\d+ \(([\d.]+)\) the targets=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)"
KERNEL = r"the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=\d+ ticks=\d+ \(([\d.]+) a record\)"
ROWS = (r"window rows ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\) the updates and the branches=\d+ \(([\d.]+)\)"
        r" the rows=\d+ \(([\d.]+)\) the values=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\); the reference's X on the taken expressions=\d+ \(([\d.]+) a record of theirs\)")
LATER = (r"window rows a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\)"
         r" the updates and the branches=\d+ \(([\d.]+)\) the rows=\d+ \(([\d.]+)\) the values=\d+ \(([\d.]+)\) an expression's part=\d+ \(([\d.]+)\)")
COUNTS = (r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+)"
          r" second-runs-that-differ=(\d+) records-swept=(\d+) entries-written=(\d+)")
DECIDED = r"window contexts expressions=(\d+) records=(\d+) decided=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) of-them-refused=(\d+) differences=(\d+) records-that-differ=(\d+)"
LISTED = r"window rows listed, by an expression's first record's reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)"
NUMBERED = r"expressions numbered=(\d+) \(([\d.]+)% of the taken\), the records their labels' walks went over=(\d+)"
CHUNKS = r"records-swept=(\d+) roots-apart-from-their-operand=\d+ chunks=(\d+)"
VALUED = r"window contexts valued=(\d+) \([\d.]+% of the records swept\) of-them-listed-for-their-target=(\d+) commas=(\d+)"
REASONS = r"window contexts listed, by an expression's first record's reason: call=(\d+) logical-or-conditional=(\d+) update=(\d+) comma(?:-or-selection)?=(\d+) division-by-a-constant=(\d+) wide-value=(\d+) operator=(\d+)"
def read(path, pattern):
    m = re.search(pattern, open(path, errors='replace').read())
    return [float(x) for x in m.groups()] if m else None
def paths(corpus, n):
    return ['%s/%s/rows-on1-%s%s-%d.txt' % (results, label, corpus, suffix, n), '%s/%s/%s-base1-%s%s-%d.txt' % (results, base, label, corpus, suffix, n),
            '%s/%s/%s-base2-%s%s-%d.txt' % (results, base, label, corpus, suffix, n), '%s/%s/rows-on2-%s%s-%d.txt' % (results, label, corpus, suffix, n)]
every = glob.glob('%s/%s/rows-on*%s-*.txt' % (results, label, suffix)) + glob.glob('%s/%s/%s-base*%s-*.txt' % (results, base, label, suffix))
print('runs: %d; without status 0: %d' % (len(every), len([p for p in every if 'status 0' not in open(p, errors='replace').read()])))
def spread(values):
    return '%6.2f (%.2f to %.2f)' % (statistics.median(values), min(values), max(values))
def signed(values):
    return '%+.2f (%+.2f to %+.2f)' % (statistics.median(values), min(values), max(values))
for corpus in ('sqlite3', 'lua', 'musl'):
    readings = []
    n = 1
    while all(glob.glob(p) for p in paths(corpus, n)):
        readings.append(paths(corpus, n))
        n += 1
    if not readings:
        continue
    for name, index, others in (('on', 0, (0, 3)), ('before', 1, (1, 2))):
        p = readings[0][index]
        c = read(p, COUNTS); d = read(p, DECIDED); l = read(p, LISTED); k = read(p, CHUNKS); u = read(p, NUMBERED)
        same = all(read(q[i], COUNTS) == c and read(q[i], DECIDED) == d and read(q[i], NUMBERED) == u for q in readings for i in others)
        print('%-8s %-7s C: expressions %d decided %d refused %d differences %d records-that-differ %d; rows: expressions %d taken %d (%.2f%%) records %d entries %d differences %d unkept %d'
              ' second-runs-that-differ %d swept %d written %d chunks %d; listed %d %d %d %d; numbered %d steps %d; the same in every run: %s  [%d readings]' % (
                  corpus, name, d[0], d[2], d[6], d[7], d[8], c[0], c[2], c[3], c[4], c[6], c[7], c[8], c[9], c[10], c[11], k[1], l[0], l[1], l[2], l[3], u[0], u[2], same, len(readings)))
        w = read(p, VALUED) or [0.0, 0.0, 0.0]; r = read(p, REASONS)
        print('%-8s %-7s C more: valued %d listed-for-their-target %d commas %d; listed: call %d logical-or-conditional %d update %d comma %d division %d wide %d operator %d' % (
            corpus, name, w[0], w[1], w[2], r[0], r[1], r[2], r[3], r[4], r[5], r[6]))
    table = {}
    for pattern, columns in ((ROWS, ("the rows' sweeps, a record swept", 'the rows, a record of the taken', 'the reads', 'the shapes', 'the updates and the branches', 'the rows', 'the values',
                                     "an expression's part", "the reference's X, a record of the taken")),
                             (LATER, ('(a second run) a record swept', '(a second run) a record of the taken', '(a second run) the reads', '(a second run) the shapes',
                                      '(a second run) the updates and the branches', '(a second run) the rows', '(a second run) the values', "(a second run) an expression's part")),
                             (CONTEXTS, ("C's sweeps, a record swept", 'C, a record of the decided', "C's loop", "C's targets", "C's expression's part", "the reference's C, a record of the decided")),
                             (CONTEXTS_LATER, ("(a second run) C's sweeps, a record swept", '(a second run) C, a record of the decided', "(a second run) C's loop", "(a second run) C's targets",
                                               "(a second run) C's expression's part")),
                             (KERNEL, ('the kernel in place, a record',)),
                             (TESTS, ('the tests on the window, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records"))):
        rows = [[read(p, pattern) for p in ps] for ps in readings]
        rows = [r for r in rows if all(r)]
        for i, column in enumerate(columns):
            on = [(r[0][i] + r[3][i]) / 2 for r in rows]; before = [(r[1][i] + r[2][i]) / 2 for r in rows]
            table[column] = (on, before)
            print('%-8s %-46s on %s  before %s  on less before %s' % (corpus, column, spread(on), spread(before), signed([a - b for a, b in zip(on, before)])))
    # A chunk's first run less its second, in ticks a chunk: (first - second, a record swept) times the records swept a chunk.
    c = read(readings[0][0], COUNTS); k = read(readings[0][0], CHUNKS)
    per_chunk = c[10] / k[1]
    for first, second, name in (("the rows' sweeps, a record swept", '(a second run) a record swept', "the rows' sweeps"), ("C's sweeps, a record swept", "(a second run) C's sweeps, a record swept", "C's sweeps")):
        on = [(a - b) * per_chunk for a, b in zip(table[first][0], table[second][0])]
        before = [(a - b) * per_chunk for a, b in zip(table[first][1], table[second][1])]
        print('%-8s %-46s on %8.0f (%.0f to %.0f)  before %8.0f (%.0f to %.0f)  on less before %+.0f (%+.0f to %+.0f)   [%.0f records a chunk]' % (
            corpus, name + ": a chunk's first run less its second, ticks a chunk", statistics.median(on), min(on), max(on), statistics.median(before), min(before), max(before),
            statistics.median([a - b for a, b in zip(on, before)]), min(a - b for a, b in zip(on, before)), max(a - b for a, b in zip(on, before)), per_chunk))
