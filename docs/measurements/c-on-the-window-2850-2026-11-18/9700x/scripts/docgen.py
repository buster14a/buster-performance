#!/usr/bin/env python3
# docgen.py RESULTS HEAD: the documents' table of TSC ticks a record for the build HEAD against m6 in the same job
# (RESULTS/HEAD and RESULTS/m6), medians of each corpus's readings, and the gate's figure from each reading's own ticks.
import re, glob, statistics, sys
results, head = sys.argv[1], sys.argv[2]
CORPORA = (('sqlite3', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl'))

def values(tag_dir, tag, corpus, pattern, group=1):
    out = []
    for path in sorted(glob.glob('%s/%s/%s-%s-*.txt' % (results, tag_dir, tag, corpus))):
        m = re.search(pattern, open(path, errors='replace').read())
        if m:
            out.append(float(m.group(group)))
    return out

def med(tag_dir, tag, corpus, pattern):
    v = values(tag_dir, tag, corpus, pattern)
    return statistics.median(v) if v else float('nan')

def front(tag_dir, tag, corpus):
    out = []
    for path in sorted(glob.glob('%s/%s/%s-%s-*.txt' % (results, tag_dir, tag, corpus))):
        m = re.search(r'the front with the window: ticks=(\d+) records=(\d+)', open(path, errors='replace').read())
        if m:
            out.append(float(m.group(1)) / float(m.group(2)))
    return statistics.median(out) if out else float('nan')

P = {
    'swept': r'window contexts ticks=\d+ \(([\d.]+) a record swept',
    'decided': r'window contexts ticks=\d+ \([\d.]+ a record swept, ([\d.]+) a record of the decided',
    'loop': r'window contexts ticks=.*the loop=\d+ \(([\d.]+)\) the targets',
    'targets': r'window contexts ticks=.*the targets=\d+ \(([\d.]+)\)',
    'part': r'window contexts ticks=.*an expression\'s part=\d+ \(([\d.]+)\); the reference',
    'reference': r'the reference\'s C on the decided expressions=\d+ \(([\d.]+) a record',
    'again': r'a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept',
    'again_loop': r'a second run over the same chunk.*the loop=\d+ \(([\d.]+)\) the targets',
    'again_targets': r'a second run over the same chunk.*the targets=\d+ \(([\d.]+)\)',
    'again_part': r'a second run over the same chunk.*an expression\'s part=\d+ \(([\d.]+)\)',
    'bytes': r'window tests ticks=.*the records\' bytes=\d+ \(([\d.]+)\)',
    'tests': r'window tests ticks=\d+ \(([\d.]+) a record\)',
    'kernel': r'the kernel in place: .* ticks=\d+ \(([\d.]+) a record\)',
}
rows = [
    ('**C on the window, a record its sweeps ran over**', lambda c: '**%.2f**' % med(head, 'window-contexts', c, P['swept'])),
    ('of which the loop', lambda c: '%.2f' % med(head, 'window-contexts', c, P['loop'])),
    ('the targets', lambda c: '%.2f' % med(head, 'window-contexts', c, P['targets'])),
    ('an expression\'s part', lambda c: '%.2f' % med(head, 'window-contexts', c, P['part'])),
    ('the same three sweeps again over the chunk', lambda c: '%.2f' % med(head, 'window-contexts', c, P['again'])),
    ('of which the loop', lambda c: '%.2f' % med(head, 'window-contexts', c, P['again_loop'])),
    ('the records\' bytes with C\'s five columns, a record of the tests\'', lambda c: '%.2f' % med(head, 'window-contexts', c, P['bytes'])),
    ('the tests\' bytes alone: main', lambda c: '%.2f' % med('m6', 'vs-%s' % head, c, P['bytes'])),
    ('with the piece, C off', lambda c: '%.2f' % med(head, 'window-tests', c, P['bytes'])),
    ('**C\'s three sweeps, a record of the decided expressions**', lambda c: '**%.1f**' % med(head, 'window-contexts', c, P['decided'])),
    ('the reference\'s C on the same expressions', lambda c: '%.1f' % med(head, 'window-contexts', c, P['reference'])),
    ('the tests on the window: main', lambda c: '%.1f' % med('m6', 'vs-%s' % head, c, P['tests'])),
    ('with the piece, C off', lambda c: '%.1f' % med(head, 'window-tests', c, P['tests'])),
    ('the kernel in place: main', lambda c: '%.1f' % med('m6', 'vs-%s' % head, c, P['kernel'])),
    ('with the piece, C off', lambda c: '%.1f' % med(head, 'window-tests', c, P['kernel'])),
    ('with C on', lambda c: '%.1f' % med(head, 'window-contexts', c, P['kernel'])),
    ('the front with the window: main', lambda c: '%.1f' % front('m6', 'vs-%s-window' % head, c)),
    ('with the piece', lambda c: '%.1f' % front(head, 'window', c)),
]
print('| | ' + ' | '.join(name for _, name in CORPORA) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in CORPORA) + ' |')
for name, f in rows:
    print('| %s | %s |' % (name, ' | '.join(f(c) for c, _ in CORPORA)))
print()
for corpus, name in CORPORA:
    tot = []; add = []; sw = []
    files = sorted(glob.glob('%s/%s/window-contexts-%s-*.txt' % (results, head, corpus)))
    for path in files:
        i = path.rsplit('-', 1)[1]
        t = open(path, errors='replace').read()
        b = open('%s/m6/vs-%s-%s-%s' % (results, head, corpus, i), errors='replace').read()
        g = lambda text, pat: float(re.search(pat, text).group(1))
        hb = g(t, r"the records' bytes=(\d+)"); bb = g(b, r"the records' bytes=(\d+)")
        c = g(t, r"window contexts ticks=(\d+)"); d = g(t, r"their-records=(\d+)")
        add.append((hb - bb) / d); sw.append(c / d); tot.append((hb - bb + c) / d)
    print('%s: %d readings; the three sweeps %.2f a record of the decided; the bytes\' five columns %.2f; together %.2f (%.2f to %.2f)' %
          (name, len(tot), statistics.median(sw), statistics.median(add), statistics.median(tot), min(tot), max(tot)))
for n in (1, 2):
    t = open('%s/%s/compile-%d.txt' % (results, head, n), errors='replace').read()
    w = re.search(r'wall time \(ms\):.*?head: .*?against base ([+-][\d.]+%).*?base-again: .*?against base ([+-][\d.]+%)', t, re.S)
    c = re.search(r'user cycles \(millions\):.*?head: .*?against base ([+-][\d.]+%).*?base-again: .*?against base ([+-][\d.]+%)', t, re.S)
    print('-c sqlite3.c, run %d: wall %s (the base again %s); user cycles %s (the base again %s)' % (n, w.group(1), w.group(2), c.group(1), c.group(2)))
