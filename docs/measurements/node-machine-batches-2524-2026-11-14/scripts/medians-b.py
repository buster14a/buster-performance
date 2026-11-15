#!/usr/bin/env python3
# medians-b.py FILE...: the median over the given time files (rounds of one build, batch and corpus) of each sweep's
# cycles a taken node: T, C (T+C less T), X (all less T+C) and all three, with each file's all-three figure.
import sys, re, statistics
rows = []
for path in sys.argv[1:]:
    c = [float(m.group(1)) for line in open(path) for m in [re.search(r'time sweeps=\S+ .*per-evaluated-node: cycles=([0-9.]+)', line)] if m]
    if len(c) == 3:
        rows.append((c[0], c[1] - c[0], c[2] - c[1], c[2]))
if rows:
    med = [statistics.median(r[k] for r in rows) for k in range(4)]
    print('T %6.1f  C %6.1f  X %6.1f  all %6.1f   (runs: %s)' % (*med, ' '.join('%.1f' % r[3] for r in rows)))
else:
    print('missing')
