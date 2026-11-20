#!/usr/bin/env python3
# second-known.py LINES...: the taken expressions with an `&&` or an `||` whose second operand, the record before it,
# has a constant (its standing's kind): what a listing of such an operator would leave out of the window's expressions.
import collections, lzma, sys
for path in sys.argv[1:]:
    c = collections.Counter()
    records, root = [], None
    def flush():
        if root is None: return
        by = {r[0]: r for r in records}
        hit = any(op in (21, 22) and (x - 1) in by and (by[x - 1][2] >> 2) & 7 != 0 for x, op, standing in records)
        integer = any(op in (21, 22) and (x - 1) in by and (by[x - 1][2] >> 2) & 7 == 1 for x, op, standing in records)
        c['expressions'] += 1; c['with such an operator'] += hit; c['of them an integer constant'] += integer
    with lzma.open(path, 'rt') as f:
        for line in f:
            p = line.split('\t')
            if p[0] == 'fw':
                flush(); root = int(p[1]); records = []
            elif p[0] == 'fr':
                records.append((int(p[3]), int(p[4]), int(p[9])))
            elif p[0] == 'fu':
                flush(); root = None; records = []
    flush()
    print(path, dict(c))
