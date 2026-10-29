#!/usr/bin/env python3
# Record A2's rule2.py with the production rule's integer form: lanes = 1 + beyond / (A + top / D), beyond = the bodies'
# tokens past max(b1, 2*b2), top = the unit's tokens outside its bodies, D = 0 for no top-level share; capped at 8 and
# the bodies. Reads grid.py --full-precision's summary of one run (every lane) and prints, for each (A, D), the worst
# change at the rule's lanes, the gains forgone against the grid's best and the units within one point of their best;
# then each unit's lanes and change for a chosen pair.
#   rule3.py RUN [A D] < summary.tsv
import sys, collections
run = sys.argv[1]
chosen = (int(sys.argv[2]), int(sys.argv[3])) if len(sys.argv) > 3 else None
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
    u = units.setdefault(row['unit'], dict(bodies=int(row['bodies']), tokens=int(row['body_tokens']), all=int(row['tokens']), b1=int(row['largest']),
                                         b2=int(row['second']), changes={1: 0.0}))
    u['changes'][int(row['lanes'])] = float(row['median'])
def at(u, lanes):
    c = u['changes']
    if lanes in c:
        return c[lanes]
    low = max(k for k in c if k < lanes)
    high = min(k for k in c if k > lanes)
    return c[low] + (c[high] - c[low]) * (lanes - low) / (high - low)
def lanes_for(u, a, d):
    path = max(u['b1'], 2 * u['b2'])
    beyond = max(0, u['tokens'] - path)
    top = u['all'] - u['tokens']
    n = a + (top // d if d != 0 else 0)
    return max(1, min(8, u['bodies'], 1 + beyond // n))
def score(a, d):
    worst = -1e9; forgone = 0.0; within = 0
    for name, u in units.items():
        c = at(u, lanes_for(u, a, d))
        best = min(u['changes'].values())
        worst = max(worst, c); forgone += c - best; within += c - best <= 1.0
    return worst, forgone, within
if chosen is None:
    print('%6s %6s %8s %8s %7s' % ('A', 'D', 'worst', 'forgone', 'within1'))
    for a in [128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096]:
        for d in [0, 64, 32, 16, 8, 6, 5, 4, 3]:
            w, f, n = score(a, d)
            print('%6d %6d %+8.2f %8.2f %7d' % (a, d, w, f, n))
else:
    a, d = chosen
    w, f, n = score(a, d)
    print('A=%d D=%d worst=%+.2f forgone=%.2f within1=%d/%d' % (a, d, w, f, n, len(units)))
    for name, u in units.items():
        k = lanes_for(u, a, d)
        best = min(u['changes'], key=lambda x: u['changes'][x])
        top = u['all'] - u['tokens']
        print('%-28s top=%6d beyond=%6d N=%6d lanes=%d change=%+5.1f best=%+5.1f@%d  %s' % (name, top, max(0, u['tokens'] - max(u['b1'], 2 * u['b2'])),
              a + (top // d if d != 0 else 0), k, at(u, k), u['changes'][best], best, ' '.join('%d:%+.1f' % (x, y) for x, y in sorted(u['changes'].items()) if x > 1)))
