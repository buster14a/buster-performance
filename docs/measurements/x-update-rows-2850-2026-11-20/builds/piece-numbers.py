#!/usr/bin/env python3
# piece-numbers.py FETCH LABEL: every number the update piece's write-ups take from job-xu.sh's final readings
# (FETCH/LABEL-table.txt by xu-table.py, and the runs' own files): a line a number, named.
import re, sys, glob
fetch, label = sys.argv[1], sys.argv[2]
table = open('%s/%s-table.txt' % (fetch, label)).read()
def row(corpus, name):
    m = re.search(r"^%s\s+%s\s+on\s+([\d.]+) \(([\d.]+) to ([\d.]+)\)\s+off\s+([\d.]+)\s+before\s+([\d.]+)\s+on less off\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)\s+on less before\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)" % (corpus, re.escape(name)), table, re.M)
    assert m, (corpus, name)
    return [float(x) for x in m.groups()]
def counts(corpus, which):
    m = re.search(r"^%s\s+%s\s+expressions (\d+) taken (\d+) \(([\d.]+)%%\) entries (\d+) differences (\d+) swept (\d+) written (\d+); listed (\d+) (\d+) (\d+) (\d+); words (\d+) lines (\d+) updates (\d+); the same in every run: (\w+)\s+\[(\d+) readings\]" % (corpus, which), table, re.M)
    assert m, (corpus, which)
    return m.groups()
print(table.splitlines()[0])
for corpus in ('sqlite3', 'lua', 'musl'):
    on = counts(corpus, 'on'); before = counts(corpus, 'before'); off = counts(corpus, 'off')
    f = glob.glob('%s/%s/rows-on1-%s-1.txt' % (fetch, label, corpus))[0]
    text = open(f, errors='replace').read()
    c = re.search(r"window contexts expressions=(\d+) records=(\d+) decided=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) of-them-refused=(\d+) differences=(\d+)", text)
    x = re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\)", text)
    fb = glob.glob('%s/xr10/%s-base1-%s-1.txt' % (fetch, label, corpus))[0]
    xb = re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\)", open(fb, errors='replace').read())
    chunks = re.search(r"records-swept=(\d+) roots-apart-from-their-operand=\d+ chunks=(\d+)", text)
    decided = int(c.group(3)); refused = int(c.group(7)); taken = int(on[1]); swept = int(on[5]); updates = int(on[13])
    print('%s readings=%s same-in-every-run on=%s off=%s before=%s' % (corpus, on[15], on[14], off[14], before[14]))
    print('%s expressions=%s taken on=%s (%s%%) before=%s (%s%%) more=%d differences on=%s off=%s before=%s' % (corpus, on[0], on[1], on[2], before[1], before[2], taken - int(before[1]), on[4], off[4], before[4]))
    print('%s decided=%d refused=%d taken-of-decided=%.2f%% before-of-decided=%.2f%%' % (corpus, decided, refused, 100.0 * taken / decided, 100.0 * int(before[1]) / decided))
    print('%s listed on: update=%s branches=%s conversion=%s floating=%s; before: update=%s branches=%s' % (corpus, on[7], on[8], on[9], on[10], before[7], before[8]))
    print('%s swept=%d updates=%d (%.2f%% of the records swept, one in %.0f) words=%s lines=%s chunks=%s (records a chunk %.0f, updates a chunk %.1f)' % (
        corpus, swept, updates, 100.0 * updates / swept, swept / updates, on[11], on[12], chunks.group(2), int(chunks.group(1)) / int(chunks.group(2)), updates / int(chunks.group(2))))
    print('%s their-records on=%s (%s%%) before=%s (%s%%) more=%d' % (corpus, x.group(5), x.group(6), xb.group(5), xb.group(6), int(x.group(5)) - int(xb.group(5))))
    for name in ("the rows' sweeps, a record swept", 'the reads', 'the shapes', 'the updates', 'the rows', "an expression's part", 'a record of the taken', "the reference's X, a record of the taken",
                 '(a second run) a record swept', '(a second run) the reads', '(a second run) the shapes', '(a second run) the updates', '(a second run) the rows', "(a second run) an expression's part",
                 'the kernel in place, a record', 'the tests on the window, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records",
                 "C's sweeps, a record swept", "C's loop", "C's targets", "C's expression's part"):
        r = row(corpus, name)
        print('%s %-42s on %.2f (%.2f to %.2f) off %.2f before %.2f | on-off %+.2f (%+.2f to %+.2f) | on-before %+.2f (%+.2f to %+.2f)' % ((corpus, name) + tuple(r)))
    u = row(corpus, 'the updates'); u2 = row(corpus, '(a second run) the updates')
    print('%s ticks an update: first run on %.1f, on less off %.1f; second run on %.1f, on less off %.1f' % (corpus, u[0] * swept / updates, u[5] * swept / updates, u2[0] * swept / updates, u2[5] * swept / updates))
    s = row(corpus, "the rows' sweeps, a record swept"); ref = row(corpus, "the reference's X, a record of the taken")
    more = int(x.group(5)) - int(xb.group(5))
    print('%s the rows cost more: %+.2f a record swept x %d = %.0f ticks; the reference on the %d records more taken at %.2f a record = %.0f ticks' % (corpus, s[8], swept, s[8] * swept, more, ref[4], more * ref[4]))
