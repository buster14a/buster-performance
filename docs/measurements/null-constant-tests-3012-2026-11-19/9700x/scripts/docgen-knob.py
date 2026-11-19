#!/usr/bin/env python3
# docgen-knob.py RESULTS LABEL: one executable with the null piece's terms on and off (job-null-knob.sh): medians of
# TSC ticks a record, each setting's fourteen runs a corpus, and each reading's own difference (the on runs' mean less
# the off runs').
import re, glob, statistics, sys
results, label = sys.argv[1], sys.argv[2]
CORPORA = (('sqlite3', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl'))
P = {
    'tests': ('tests', r'window tests ticks=\d+ \(([\d.]+) a record\)'),
    'bytes': ('tests', r"window tests ticks=.*the records' bytes=\d+ \(([\d.]+)\)"),
    'kernel': ('contexts', r'the kernel in place: .* ticks=\d+ \(([\d.]+) a record\)'),
    'decided': ('contexts', r'window contexts ticks=\d+ \([\d.]+ a record swept, ([\d.]+) a record of the decided'),
}
NAMES = {'tests': 'the tests on the window, C off', 'bytes': "the tests' bytes alone", 'kernel': 'the kernel in place', 'decided': "C's three sweeps, a record of the decided"}
def value(mode, setting, corpus, n, pattern):
    try:
        text = open('%s/%s/%s-%s-%s-%d.txt' % (results, label, mode, setting, corpus, n), errors='replace').read()
    except OSError:
        return None
    m = re.search(pattern, text)
    return float(m.group(1)) if m and 'status 0' in text else None
print('| | ' + ' | '.join(name for _, name in CORPORA) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in CORPORA) + ' |')
detail = []
for key in ('tests', 'bytes', 'kernel', 'decided'):
    mode, pattern = P[key]
    cells = []
    for corpus, name in CORPORA:
        on, off, own = [], [], []
        for n in range(1, 100):
            a = [value(mode, s, corpus, n, pattern) for s in ('on1', 'on2')]
            b = [value(mode, s, corpus, n, pattern) for s in ('off1', 'off2')]
            if None in a or None in b:
                if a == [None, None] and b == [None, None]:
                    break
                continue
            on += a; off += b; own.append(sum(a) / 2 - sum(b) / 2)
        if on:
            cells.append('%.2f, %.2f' % (statistics.median(on), statistics.median(off)))
            detail.append('%s, %s: %d readings; on %.2f (%.2f to %.2f), off %.2f (%.2f to %.2f); on less off, each reading\'s own: %+.2f (%+.2f to %+.2f)' % (
                NAMES[key], name, len(own), statistics.median(on), min(on), max(on), statistics.median(off), min(off), max(off), statistics.median(own), min(own), max(own)))
        else:
            cells.append('nan')
    print('| %s: the terms on, off | %s |' % (NAMES[key], ' | '.join(cells)))
print()
print('\n'.join(detail))
