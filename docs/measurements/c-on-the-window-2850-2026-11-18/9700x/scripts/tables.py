#!/usr/bin/env python3
# tables.py RESULTS LABEL TAG...: the medians (and the least and the most) of a 9700X job's readings, a corpus a column:
# the tests on the window's sweeps, C on the window's, the kernel in place and the front with the window, from the files
# RESULTS/LABEL/TAG-<corpus>-N.txt of each LABEL/TAG named ("m6/vs-cw1").
import sys, re, glob, statistics

CORPORA = ('sqlite3', 'lua', 'musl')
PATTERNS = (
    ('the tests on the window', r'window tests ticks=\d+ \(([\d.]+) a record\)'),
    ('  the records\' bytes', r'window tests ticks=.*the records\' bytes=\d+ \(([\d.]+)\)'),
    ('  the loop', r'window tests ticks=.*the loop=\d+ \(([\d.]+)\) an expression'),
    ('  an expression\'s part', r'window tests ticks=.*an expression\'s part=\d+ \(([\d.]+)\)'),
    ('  the tests on T\'s records', r'the tests on T\'s records=\d+ \(([\d.]+)\)'),
    ('C on the window, a record swept', r'window contexts ticks=\d+ \(([\d.]+) a record swept'),
    ('  a record of the decided', r'window contexts ticks=\d+ \([\d.]+ a record swept, ([\d.]+) a record of the decided'),
    ('  the loop', r'window contexts ticks=.*the loop=\d+ \(([\d.]+)\) the targets'),
    ('  the targets', r'window contexts ticks=.*the targets=\d+ \(([\d.]+)\)'),
    ('  an expression\'s part', r'window contexts ticks=.*an expression\'s part=\d+ \(([\d.]+)\); the reference'),
    ('  the reference\'s C, a record of the decided', r'the reference\'s C on the decided expressions=\d+ \(([\d.]+) a record'),
    ('C a second time, a record swept', r'a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept'),
    ('  the loop', r'a second run over the same chunk.*the loop=\d+ \(([\d.]+)\) the targets'),
    ('  the targets', r'a second run over the same chunk.*the targets=\d+ \(([\d.]+)\)'),
    ('  an expression\'s part', r'a second run over the same chunk.*an expression\'s part=\d+ \(([\d.]+)\)'),
    ('the kernel in place', r'the kernel in place: .* ticks=\d+ \(([\d.]+) a record\)'),
    ('the front with the window', None),
    ('the names\' pass, a name', None),
)


def front(text):
    m = re.search(r'the front with the window: ticks=(\d+) records=(\d+)', text)
    return float(m.group(1)) / float(m.group(2)) if m and int(m.group(2)) else None


def names(text):
    m = re.search(r'the names\' pass: names=(\d+) ticks=(\d+)', text)
    return float(m.group(2)) / float(m.group(1)) if m and int(m.group(1)) else None


def main():
    results = sys.argv[1]
    for spec in sys.argv[2:]:
        label, tag = spec.split('/')
        print('== %s %s' % (label, tag))
        rows = {name: {} for name, _ in PATTERNS}
        order = [name for name, _ in PATTERNS]
        seen = {}
        for corpus in CORPORA:
            files = sorted(glob.glob('%s/%s/%s-%s-*.txt' % (results, label, tag, corpus)))
            values = {i: [] for i in range(len(PATTERNS))}
            bad = 0
            for path in files:
                text = open(path, errors='replace').read()
                if not text.rstrip().endswith('status 0') and 'status 0' not in text[-200:]:
                    bad += 1
                for i, (name, pattern) in enumerate(PATTERNS):
                    value = None
                    if pattern is not None:
                        m = re.search(pattern, text)
                        value = float(m.group(1)) if m else None
                    elif name.startswith('the front'):
                        value = front(text)
                    else:
                        value = names(text)
                    if value is not None:
                        values[i].append(value)
            seen[corpus] = (len(files), bad, values)
        print('   readings: %s' % ', '.join('%s %d%s' % (c, seen[c][0], ' (%d not status 0)' % seen[c][1] if seen[c][1] else '') for c in CORPORA))
        for i, (name, _) in enumerate(PATTERNS):
            cells = []
            for corpus in CORPORA:
                v = seen[corpus][2][i]
                cells.append('%7.2f (%6.2f..%6.2f)' % (statistics.median(v), min(v), max(v)) if v else '        -              ')
            if any('-' not in c[:10] for c in cells):
                print('   %-46s %s' % (name, '  '.join(cells)))


main()
