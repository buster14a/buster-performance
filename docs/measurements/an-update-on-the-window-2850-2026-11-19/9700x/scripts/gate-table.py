#!/usr/bin/env python3
# gate-table.py RESULTS BASE HEAD...: the gate's figure (C's three sweeps and the records' bytes' columns for C, TSC
# ticks a record of the decided) of the build before and of each HEAD in HEAD's own job: medians of the readings, and
# each reading's own difference.
import re, glob, statistics, sys
results, base, heads = sys.argv[1], sys.argv[2], sys.argv[3:]
g = lambda text, pat: float(re.search(pat, text).group(1))
for head in heads:
    for corpus in ('sqlite3', 'lua', 'musl'):
        H = []; B = []; D = []
        for path in sorted(glob.glob('%s/%s/window-contexts-%s-*.txt' % (results, head, corpus))):
            i = path.rsplit('-', 1)[1]
            t = open(path, errors='replace').read()
            bt = open('%s/%s/vs-%s-%s-%s' % (results, base, head, corpus, i), errors='replace').read()
            bc = open('%s/%s/contexts-vs-%s-%s-%s' % (results, base, head, corpus, i), errors='replace').read()
            hb = g(t, r"the records' bytes=(\d+)"); bb = g(bt, r"the records' bytes=(\d+)"); bcb = g(bc, r"the records' bytes=(\d+)")
            c = g(t, r"window contexts ticks=(\d+)"); d = g(t, r"their-records=(\d+)")
            cb = g(bc, r"window contexts ticks=(\d+)"); db = g(bc, r"their-records=(\d+)")
            H.append((hb - bb + c) / d); B.append((bcb - bb + cb) / db); D.append((hb - bb + c) / d - (bcb - bb + cb) / db)
        print('%-6s %-8s readings %2d  before %.2f (%.2f to %.2f)  with %.2f (%.2f to %.2f)  each reading\'s own difference %+.2f (%+.2f to %+.2f)' % (
            head, corpus, len(H), statistics.median(B), min(B), max(B), statistics.median(H), min(H), max(H), statistics.median(D), min(D), max(D)))
