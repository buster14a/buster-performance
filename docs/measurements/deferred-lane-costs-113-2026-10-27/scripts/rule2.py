#!/usr/bin/env python3
# Evaluates the lane rule with N growing with the top level: lanes = 1 + beyond / (A + B * top), beyond = the bodies'
# tokens past max(b1, 2*b2), top = the unit's tokens outside its bodies; capped at 8 and the bodies. Reads grid.py's
# summary of one run (every lane) and prints, for each (A, B), the worst change at the rule's lanes, the gains forgone
# against the grid's best, and the units within 1% of their best; then each unit's lanes and change for the chosen pair.
#   rule2.py RUN [A B] < summary.tsv
import sys, collections
run = sys.argv[1]
chosen = (int(sys.argv[2]), float(sys.argv[3])) if len(sys.argv) > 3 else None
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
                                         b2=int(row['second']), changes={1: 0.0}, spread={1: (0.0, 0.0)}))
    u['changes'][int(row['lanes'])] = float(row['median'])
    u['spread'][int(row['lanes'])] = (float(row['low']), float(row['high']))
def at(u, lanes):
    c = u['changes']
    if lanes in c:
        return c[lanes]
    low = max(k for k in c if k < lanes)
    high = min(k for k in c if k > lanes)
    return c[low] + (c[high] - c[low]) * (lanes - low) / (high - low)
def lanes_for(u, a, b):
    path = max(u['b1'], 2 * u['b2'])
    beyond = max(0, u['tokens'] - path)
    top = u['all'] - u['tokens']
    n = a + b * top
    return max(1, min(8, u['bodies'], 1 + int(beyond // n)))
def score(a, b):
    worst = -1e9; forgone = 0.0; within = 0
    for name, u in units.items():
        c = at(u, lanes_for(u, a, b))
        best = min(u['changes'].values())
        worst = max(worst, c); forgone += c - best; within += c - best <= 1.0
    return worst, forgone, within
if chosen is None:
    print('%6s %6s %8s %8s %7s' % ('A', 'B', 'worst', 'forgone', 'within1'))
    for a in [1024, 1536, 2048, 3072, 4096, 6144, 8192]:
        for b in [0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.4]:
            w, f, n = score(a, b)
            print('%6d %6.2f %+8.1f %8.1f %7d' % (a, b, w, f, n))
else:
    a, b = chosen
    w, f, n = score(a, b)
    print('A=%d B=%.2f worst=%+.1f forgone=%.1f within1=%d/%d' % (a, b, w, f, n, len(units)))
    for name, u in units.items():
        k = lanes_for(u, a, b)
        best = min(u['changes'], key=lambda x: u['changes'][x])
        print('%-28s top=%6d beyond=%6d N=%6d lanes=%d change=%+5.1f best=%+5.1f@%d  %s' % (name, u['all'] - u['tokens'], max(0, u['tokens'] - max(u['b1'], 2 * u['b2'])),
              a + b * (u['all'] - u['tokens']), k, at(u, k), u['changes'][best], best, ' '.join('%d:%+.1f' % (x, y) for x, y in sorted(u['changes'].items()) if x > 1)))
