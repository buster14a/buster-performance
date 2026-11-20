#!/usr/bin/env python3
# tables.py RECORD: medians of record.sh's runs.tsv (5 rounds of each script, each a mean of 3 perf runs) and cost.tsv
# (11 runs a tree), head/base ratios, as Markdown tables.
import sys, statistics
d = sys.argv[1]
def rows(name):
    out = []
    for line in open(f'{d}/{name}'):
        f = line.rstrip('\n').split('\t')
        if len(f) < 4: continue
        kv = dict(x.split('=', 1) for x in f[3:] if '=' in x)
        out.append((f[0], f[1], f[2], {k: float(v) for k, v in kv.items()}))
    return out
def table(name, title, keys):
    r = rows(name)
    items = sorted({x[2] for x in r}, key=lambda s: [x[2] for x in r].index(s))
    print(f'### {title}\n')
    print('| | ' + ' | '.join(f'base {k}' + ' | ' + f'head {k}' + ' | head/base' for k in keys) + ' |')
    print('| --- |' + ' ---: |' * (3 * len(keys)))
    geo = {k: [] for k in keys}
    for it in items:
        cells = []
        for k in keys:
            b = statistics.median(x[3][k] for x in r if x[0] == 'base' and x[2] == it)
            h = statistics.median(x[3][k] for x in r if x[0] == 'head' and x[2] == it)
            geo[k].append(h / b)
            cells += [f'{b/1e6:,.1f} M' if k != 'task-clock' else f'{b:.2f} ms', f'{h/1e6:,.1f} M' if k != 'task-clock' else f'{h:.2f} ms', f'{h/b:.4f}']
        n = len([x for x in r if x[0] == 'base' and x[2] == it])
        print(f'| {it} (n={n}) | ' + ' | '.join(cells) + ' |')
    if len(items) > 1:
        import math
        cells = []
        for k in keys:
            cells += ['', '', f'{math.exp(sum(map(math.log, geo[k])) / len(geo[k])):.4f}']
        print('| geometric mean | ' + ' | '.join(cells) + ' |')
    print()
table('runs.tsv', "Lua's scripts (medians of 5 rounds, each a mean of 3 runs)", ['cycles:u', 'instructions:u'])
table('cost.tsv', 'Compile cost (medians of 11 alternating runs)', ['cycles:u', 'instructions:u', 'task-clock'])
