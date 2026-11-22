#!/usr/bin/env python3
# analyze.py AB.LOG...: from ab's time-runs per-process lines, each build's medians of user cycles and instructions
# per hold (a round's time-runs process) for each workload, then the paired per-hold ratios of the pairs below:
# their median and range over holds, and the pooled medians over every process.
import re, statistics, sys
pairs = [('pr3130', 'main'), ('pr3143', 'pr3130'), ('pr3143', 'main'), ('main-again', 'main')]
line = re.compile(r'^run \d+ list (\d+) (\S+) copy (\d+): ([\d.]+) ms wall, ([\d.]+) ms user, .* (\d+) user cycles, (\d+) instructions, status (\d+)')
head = re.compile(r'^== round (\d+) tree \S+ config \[time-runs .*--list (.*)\]')
holds = []  # (workload, {build: {metric: [values]}})
for path in sys.argv[1:]:
    current = None
    for text in open(path):
        h = head.match(text)
        if h:
            args = h.group(2)
            workload = 'sqlite' if 'sqlite3.c' in args else 'lparser' if 'lparser.c' in args else args
            current = (workload, {})
            holds.append(current)
            continue
        m = line.match(text)
        if m and current is not None:
            assert m.group(8) == '0', text
            d = current[1].setdefault(m.group(2), {'cycles': [], 'instructions': [], 'wall': []})
            d['cycles'].append(int(m.group(6))); d['instructions'].append(int(m.group(7))); d['wall'].append(float(m.group(4)))
def pct(a, b): return (a / b - 1) * 100
for workload in sorted({w for w, _ in holds}):
    mine = [d for w, d in holds if w == workload and d]
    print(f'{workload}: {len(mine)} holds, {sum(len(d["main"]["cycles"]) for d in mine)} processes of main')
    for build in ['main', 'pr3130', 'pr3143', 'main-again']:
        allc = [v for d in mine for v in d[build]['cycles']]; alli = [v for d in mine for v in d[build]['instructions']]; allw = [v for d in mine for v in d[build]['wall']]
        print(f'  {build:10s} pooled medians: {statistics.median(alli):,.0f} instructions (min {min(alli):,} max {max(alli):,}), {statistics.median(allc):,.0f} user cycles (min {min(allc):,} max {max(allc):,}), {statistics.median(allw):.3f} ms wall, n={len(allc)}')
    for a, b in pairs:
        for metric in ['instructions', 'cycles']:
            ratios = [pct(statistics.median(d[a][metric]), statistics.median(d[b][metric])) for d in mine]
            pooled = pct(statistics.median([v for d in mine for v in d[a][metric]]), statistics.median([v for d in mine for v in d[b][metric]]))
            print(f'  {a} vs {b} {metric}: pooled {pooled:+.3f}%; per hold median {statistics.median(ratios):+.3f}% [{min(ratios):+.3f}%, {max(ratios):+.3f}%] over {len(ratios)} holds; {sum(r < 0 for r in ratios)} of {len(ratios)} below zero')
