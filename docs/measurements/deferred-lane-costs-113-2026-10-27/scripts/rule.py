#!/usr/bin/env python3
# Evaluates lane rules against a grid (grid.py's summary of one run, every lane): for each unit, the median change of
# its reading on each measured lane count against one lane (counts between measured ones interpolated), and for each rule
# (the critical path's form, and N) the lanes it gives and its change there, beside the grid's best.
#   rule.py RUN [N...] < summary.tsv
# Feed grid.py --full-precision output so thresholds and sums precede display rounding.
import sys, collections
run = sys.argv[1]
ns = [int(x) for x in sys.argv[2:]] or [8192, 10240, 12288, 14336, 16384]
units = collections.OrderedDict()
header = None
for line in sys.stdin:
    cells = line.rstrip('\n').split('\t')
    if header is None:
        header = cells
        continue
    row = dict(zip(header, cells))
    if row['run'] != run:
        continue
    u = units.setdefault(row['unit'], dict(bodies=int(row['bodies']), tokens=int(row['body_tokens']), b1=int(row['largest']), b2=int(row['second']), changes={1: 0.0}))
    u['changes'][int(row['lanes'])] = float(row['median'])
def at(u, lanes):
    c = u['changes']
    if lanes in c:
        return c[lanes]
    low = max(k for k in c if k < lanes)
    highs = [k for k in c if k > lanes]
    if not highs:
        return None
    high = min(highs)
    return c[low] + (c[high] - c[low]) * (lanes - low) / (high - low)
forms = {
    '2*b1': lambda u: 2 * u['b1'],
    'b1': lambda u: u['b1'],
    'max(b1,2*b2)': lambda u: max(u['b1'], 2 * u['b2']),
}
def lanes_for(u, path, n):
    beyond = max(0, u['tokens'] - path)
    return max(1, min(8, u['bodies'], 1 + beyond // n))
print('%-28s %7s %6s %6s %6s %6s' % ('unit', 'tokens', 'b1', 'b2', 'best', 'at'))
for name, u in units.items():
    best = min(u['changes'], key=lambda k: u['changes'][k])
    print('%-28s %7d %6d %6d %+6.1f %6d  %s' % (name, u['tokens'], u['b1'], u['b2'], u['changes'][best], best,
                                                ' '.join('%d:%+.1f' % (k, v) for k, v in sorted(u['changes'].items()) if k > 1)))
print()
print('%-14s %6s %8s %8s %8s %8s' % ('form', 'N', 'worst', 'forgone', 'within1', 'units'))
for fname, f in forms.items():
    for n in ns:
        worst = -1e9
        forgone = 0.0
        within = 0
        for name, u in units.items():
            k = lanes_for(u, f(u), n)
            c = at(u, k)
            if c is None:
                continue
            best = min(u['changes'].values())
            worst = max(worst, c)
            forgone += c - best
            within += c - best <= 1.0
        print('%-14s %6d %+8.1f %8.1f %8d %8d' % (fname, n, worst, forgone, within, len(units)))
