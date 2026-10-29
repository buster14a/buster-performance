#!/usr/bin/env python3
# Campaign M7 (#847): each unit's medians over the rounds of main as #791's branch has it (NEW) and the main #764's
# campaigns measured (OLD), each by its rule on up to 8 lanes: the reading, one lane's and source order's, and NEW's
# change against OLD.
#   m7sum.py LOG NEW OLD
import collections, re, statistics, sys
log, new, old = sys.argv[1:4]
runs = collections.defaultdict(list)
tokens = {}
cur = None
for line in open(log, errors='replace'):
    if line.startswith('== round '):
        p = line.split()
        cur = dict(name=p[3], unit=p[4])
        runs[(p[3], p[4])].append(cur)
    elif cur is not None and line.startswith('checker-deferred: file='):
        tokens[cur['unit']] = int(re.search(r'tokens=(\d+)', line).group(1))
        cur['source'] = float(re.search(r'source_order=([\d.]+)', line).group(1))
    elif cur is not None and line.startswith('checker-deferred:   lanes='):
        m = re.match(r'checker-deferred:   lanes=(\d+) active=(\d+) .*whole=([\d.]+)', line)
        if m:
            cur[int(m.group(1))] = (int(m.group(2)), float(m.group(3)))
    elif cur is not None and line.startswith('exit='):
        cur['exit'] = line.split()[0]
print('| Unit | Tokens | Lanes | New | Old | New against old | One lane: new against old | Source order: new against old |')
print('| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: |')
for unit in sorted({u for (_, u) in runs}, key=lambda u: tokens[u]):
    def med(name, key, index=1):
        values = [r[key][index] if isinstance(r[key], tuple) else r[key] for r in runs[(name, unit)] if key in r]
        return statistics.median(values)
    lanes = f'{med(new, 8, 0):.0f}/{med(old, 8, 0):.0f}'
    w = (med(new, 8), med(old, 8))
    one = (med(new, 1), med(old, 1))
    so = (med(new, 'source'), med(old, 'source'))
    print(f'| `{unit}.c` | {tokens[unit]} | {lanes} | {w[0]:.2f} | {w[1]:.2f} | {100 * (w[0] / w[1] - 1):+.1f}% | {100 * (one[0] / one[1] - 1):+.1f}% | {100 * (so[0] / so[1] - 1):+.1f}% |')
bad = [(k, r.get('exit')) for k, rs in runs.items() for r in rs if r.get('exit') != 'exit=0']
print(f'\nruns: {sum(len(v) for v in runs.values())}, failed: {bad[:3]}')
