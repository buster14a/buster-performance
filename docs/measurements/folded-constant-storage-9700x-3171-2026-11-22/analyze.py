#!/usr/bin/env python3
# analyze.py AB.LOG...: from ab's time-runs per-process lines, each build's medians of wall time, user cycles and
# instructions per hold (a round's time-runs process), then the paired per-hold changes of head and main-again (the
# floor) against main: their median, range and how many holds fell below and above zero, and the pooled medians.
import re, statistics, sys
pairs = [('head', 'main'), ('main-again', 'main')]
line = re.compile(r'^run \d+ list (\d+) (\S+) copy (\d+): ([\d.]+) ms wall, ([\d.]+) ms user, .* (\d+) user cycles, (\d+) instructions, status (\d+)')
head = re.compile(r'^== round (\d+) tree ')
holds = []
for path in sys.argv[1:]:
    current = None
    for text in open(path):
        if head.match(text):
            current = {}
            holds.append(current)
            continue
        m = line.match(text)
        if m and current is not None:
            assert m.group(8) == '0', text
            d = current.setdefault(m.group(2), {'wall': [], 'cycles': [], 'instructions': []})
            d['wall'].append(float(m.group(4))); d['cycles'].append(int(m.group(6))); d['instructions'].append(int(m.group(7)))
def pct(a, b): return (a / b - 1) * 100
mine = [d for d in holds if d]
print(f'-c sqlite3.c, CPU 2: {len(mine)} holds, {sum(len(d["main"]["wall"]) for d in mine)} processes of each build')
for build in ['main', 'head', 'main-again']:
    allw = [v for d in mine for v in d[build]['wall']]; allc = [v for d in mine for v in d[build]['cycles']]; alli = [v for d in mine for v in d[build]['instructions']]
    print(f'  {build:10s} pooled medians: {statistics.median(allw):.3f} ms wall, {statistics.median(allc):,.0f} user cycles, {statistics.median(alli):,.0f} instructions (min {min(alli):,} max {max(alli):,}), n={len(allw)}')
for a, b in pairs:
    for metric in ['wall', 'cycles', 'instructions']:
        ratios = [pct(statistics.median(d[a][metric]), statistics.median(d[b][metric])) for d in mine]
        pooled = pct(statistics.median([v for d in mine for v in d[a][metric]]), statistics.median([v for d in mine for v in d[b][metric]]))
        print(f'  {a} vs {b} {metric}: pooled {pooled:+.3f}%; per hold median {statistics.median(ratios):+.3f}% [{min(ratios):+.3f}%, {max(ratios):+.3f}%]; {sum(r < 0 for r in ratios)} of {len(ratios)} holds below zero, {sum(r > 0 for r in ratios)} above')
        print('    per hold: ' + ' '.join(f'{r:+.3f}%' for r in ratios))
