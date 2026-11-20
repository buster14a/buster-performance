#!/usr/bin/env python3
# builds.py FETCH: the update piece's builds' readings on the 9700X, from xu-table.py's tables of job-xu.sh's runs
# (FETCH/xuN-table.txt): for each build and corpus the rows' sweeps a record swept with the update's rows on, off and
# in the piece before's executable, the parts' on less before, and the updates' own counter.
import re, sys
fetch = sys.argv[1]
def rows(label):
    out = {}
    for line in open('%s/%s-table.txt' % (fetch, label)):
        m = re.match(r"(\S+)\s+(.+?)\s+on\s+([\d.]+) \(([\d.]+) to ([\d.]+)\)\s+off\s+([\d.]+)\s+before\s+([\d.]+)\s+on less off\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)\s+on less before\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)", line)
        if m:
            out[(m.group(1), m.group(2).strip())] = [float(x) for x in m.groups()[2:]]
    return out
for label in sys.argv[2:]:
    r = rows(label)
    for corpus in ('sqlite3', 'lua', 'musl'):
        t = r[(corpus, "the rows' sweeps, a record swept")]
        parts = ' '.join('%s %+.2f' % (name.split()[-1], r[(corpus, name)][8]) for name in ('the reads', 'the shapes', 'the updates', 'the rows', "an expression's part") if (corpus, name) in r)
        u = r.get((corpus, 'the updates')); u2 = r.get((corpus, '(a second run) the updates')); s2 = r[(corpus, '(a second run) a record swept')]
        print('%-4s %-8s on %.2f (%.2f to %.2f) off %.2f before %.2f | on-off %+.2f | on-before %+.2f (%+.2f to %+.2f) | parts on-before: %s | updates on %s off %s; second run on %s off %s | second run sum on %.2f before %.2f (%+.2f)' % (
            label, corpus, t[0], t[1], t[2], t[3], t[4], t[5], t[8], t[9], t[10], parts,
            '%.2f' % u[0] if u else '-', '%.2f' % u[3] if u else '-', '%.2f' % u2[0] if u2 else '-', '%.2f' % u2[3] if u2 else '-', s2[0], s2[4], s2[8]))
