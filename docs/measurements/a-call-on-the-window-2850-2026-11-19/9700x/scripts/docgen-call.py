#!/usr/bin/env python3
# docgen-call.py RESULTS HEAD BASE: the documents' table of TSC ticks a record for the call piece's build HEAD against
# BASE in the same job (RESULTS/HEAD and RESULTS/BASE), medians of each corpus's readings; the gate's figure (C's
# sweeps with the records' bytes, a record of the decided) from each reading's own ticks; the arguments' rule's
# answers; and -c sqlite3.c.
import re, glob, statistics, sys
results, head, base = sys.argv[1], sys.argv[2], sys.argv[3]
CORPORA = (('sqlite3', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl'))

def values(tag_dir, tag, corpus, pattern):
    out = []
    for path in sorted(glob.glob('%s/%s/%s-%s-*.txt' % (results, tag_dir, tag, corpus))):
        m = re.search(pattern, open(path, errors='replace').read())
        if m:
            out.append(float(m.group(1)))
    return out

def med(tag_dir, tag, corpus, pattern):
    v = values(tag_dir, tag, corpus, pattern)
    return statistics.median(v) if v else float('nan')

def spread(tag_dir, tag, corpus, pattern):
    v = values(tag_dir, tag, corpus, pattern)
    return '%.2f (%.2f to %.2f)' % (statistics.median(v), min(v), max(v)) if v else 'nan'

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
    'bytes': r'window tests ticks=.*the records\' bytes=\d+ \(([\d.]+)\)',
    'tests': r'window tests ticks=\d+ \(([\d.]+) a record\)',
    'kernel': r'the kernel in place: .* ticks=\d+ \(([\d.]+) a record\)',
    'answers': r"the arguments' rule's answers=(\d+)",
    'timed': r"of-them-in-the-timed-run=(\d+)",
    'answer': r"of-them-in-the-timed-run=\d+ ticks=\d+ \(([\d.]+) an answer\)",
}
B = 'contexts-vs-%s' % head
rows = [
    ('**the kernel in place: before**', lambda c: '**%.2f**' % med(base, B, c, P['kernel'])),
    ('**with the piece**', lambda c: '**%.2f**' % med(head, 'window-contexts', c, P['kernel'])),
    ('the same two with C off', lambda c: '%.2f, %.2f' % (med(base, 'vs-%s' % head, c, P['kernel']), med(head, 'window-tests', c, P['kernel']))),
    ('**C\'s three sweeps, a record of the decided: before**', lambda c: '**%.2f**' % med(base, B, c, P['decided'])),
    ('**with the piece**', lambda c: '**%.2f**' % med(head, 'window-contexts', c, P['decided'])),
    ('the reference\'s C on the same expressions: before, with', lambda c: '%.1f, %.1f' % (med(base, B, c, P['reference']), med(head, 'window-contexts', c, P['reference']))),
    ('C\'s sweeps, a record they ran over: before', lambda c: '%.2f' % med(base, B, c, P['swept'])),
    ('with the piece', lambda c: '%.2f' % med(head, 'window-contexts', c, P['swept'])),
    ('of which the loop: before, with', lambda c: '%.2f, %.2f' % (med(base, B, c, P['loop']), med(head, 'window-contexts', c, P['loop']))),
    ('the targets: before, with', lambda c: '%.2f, %.2f' % (med(base, B, c, P['targets']), med(head, 'window-contexts', c, P['targets']))),
    ('an expression\'s part: before, with', lambda c: '%.2f, %.2f' % (med(base, B, c, P['part']), med(head, 'window-contexts', c, P['part']))),
    ('the records\' bytes with C\'s columns: before, with', lambda c: '%.2f, %.2f' % (med(base, B, c, P['bytes']), med(head, 'window-contexts', c, P['bytes']))),
    ('the tests\' bytes alone: before, with', lambda c: '%.2f, %.2f' % (med(base, 'vs-%s' % head, c, P['bytes']), med(head, 'window-tests', c, P['bytes']))),
    ('the tests on the window, C off: before, with', lambda c: '%.1f, %.1f' % (med(base, 'vs-%s' % head, c, P['tests']), med(head, 'window-tests', c, P['tests']))),
    ('the front with the window: before, with', lambda c: '%.1f, %.1f' % (front(base, 'vs-%s-window' % head, c), front(head, 'window', c))),
    ('the arguments\' rule\'s answers, of them in the timed run', lambda c: '%d, %d' % (med(head, 'window-contexts', c, P['answers']), med(head, 'window-contexts', c, P['timed']))),
    ('ticks an answer', lambda c: '%.0f' % med(head, 'window-contexts', c, P['answer'])),
]
print('| | ' + ' | '.join(name for _, name in CORPORA) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in CORPORA) + ' |')
for name, f in rows:
    print('| %s | %s |' % (name, ' | '.join(f(c) for c, _ in CORPORA)))
print()
for corpus, name in CORPORA:
    print('%s: the kernel in place before %s, with %s' % (name, spread(base, B, corpus, P['kernel']), spread(head, 'window-contexts', corpus, P['kernel'])))
for corpus, name in CORPORA:
    tot = []; add = []; sw = []; rise = []
    files = sorted(glob.glob('%s/%s/window-contexts-%s-*.txt' % (results, head, corpus)))
    for path in files:
        i = path.rsplit('-', 1)[1]
        t = open(path, errors='replace').read()
        b = open('%s/%s/vs-%s-%s-%s' % (results, base, head, corpus, i), errors='replace').read()
        bc = open('%s/%s/%s-%s-%s' % (results, base, B, corpus, i), errors='replace').read()
        g = lambda text, pat: float(re.search(pat, text).group(1))
        hb = g(t, r"the records' bytes=(\d+)"); bb = g(b, r"the records' bytes=(\d+)")
        c = g(t, r"window contexts ticks=(\d+)"); d = g(t, r"their-records=(\d+)")
        add.append((hb - bb) / d); sw.append(c / d); tot.append((hb - bb + c) / d)
        hk = g(t, r"the kernel in place: .* ticks=(\d+)"); bk = g(bc, r"the kernel in place: .* ticks=(\d+)"); hr = hk / g(t, r"the kernel in place: .* ticks=\d+ \(([\d.]+) a record\)")
        rise.append((hk - bk) / hr)
    print('%s: %d readings; the three sweeps %.2f a record of the decided; the bytes\' columns %.2f; together %.2f (%.2f to %.2f); the kernel in place over the build before, each reading\'s own: %.2f (%.2f to %.2f)' %
          (name, len(tot), statistics.median(sw), statistics.median(add), statistics.median(tot), min(tot), max(tot), statistics.median(rise), min(rise), max(rise)))
for n in (1, 2):
    try:
        t = open('%s/%s/compile-%d.txt' % (results, head, n), errors='replace').read()
    except OSError:
        continue
    w = re.search(r'wall time \(ms\):.*?head: .*?against base ([+-][\d.]+%).*?base-again: .*?against base ([+-][\d.]+%)', t, re.S)
    c = re.search(r'user cycles \(millions\):.*?head: .*?against base ([+-][\d.]+%).*?base-again: .*?against base ([+-][\d.]+%)', t, re.S)
    if w and c:
        print('-c sqlite3.c, run %d: wall %s (the base again %s); user cycles %s (the base again %s)' % (n, w.group(1), w.group(2), c.group(1), c.group(2)))
