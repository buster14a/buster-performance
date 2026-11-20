#!/usr/bin/env python3
# builds-detail.py FETCH LABEL...: for each build's table (xu-table.py's), each part's on, off and before and their
# differences on sqlite3.c and Lua, and the reads' and the updates' on less off as ticks an update.
import re, sys
fetch = sys.argv[1]
updates = {'sqlite3': 3734, 'lua': 861, 'musl': 3969}
swept = {'sqlite3': 321434, 'lua': 91252, 'musl': 377187}
for label in sys.argv[2:]:
    table = open('%s/%s-table.txt' % (fetch, label)).read()
    for corpus in ('sqlite3', 'lua'):
        m = re.search(r"^%s\s+on\s+expressions (\d+) taken (\d+) .* swept (\d+) .* updates (\d+);" % corpus, table, re.M)
        assert int(m.group(3)) == swept[corpus], (label, corpus, m.group(3))
        for name in ('the reads', 'the shapes', 'the updates', 'the rows', "an expression's part", '(a second run) the reads', '(a second run) the shapes', '(a second run) the updates', '(a second run) the rows'):
            r = re.search(r"^%s\s+%s\s+on\s+([\d.]+) \(([\d.]+) to ([\d.]+)\)\s+off\s+([\d.]+)\s+before\s+([\d.]+)\s+on less off\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)\s+on less before\s+([+-][\d.]+)" % (corpus, re.escape(name)), table, re.M)
            if not r:
                continue
            on, lo, hi, off, before, d, dlo, dhi, e = [float(x) for x in r.groups()]
            print('%-4s %-8s %-28s on %.2f off %.2f before %.2f | on-off %+.2f (%.1f ticks an update) | off-before %+.2f | on-before %+.2f' % (label, corpus, name, on, off, before, d, d * swept[corpus] / updates[corpus], off - before, e))
