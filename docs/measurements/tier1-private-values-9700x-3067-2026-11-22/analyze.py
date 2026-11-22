#!/usr/bin/env python3
# analyze.py AB.LOG...: from ab's time-runs per-process lines, each build's medians of wall time, user cycles and
# instructions per hold (a round's time-runs process) for each workload (input set and core count), then the paired
# per-hold changes of pr and main-again (the floor) against main: their median, range and how many holds fell below
# zero, and the pooled medians over every process.
import re, statistics, sys
pairs = [('pr', 'main'), ('main-again', 'main')]
line = re.compile(r'^run \d+ list (\d+) (\S+) copy (\d+): ([\d.]+) ms wall, ([\d.]+) ms user, .* (\d+) user cycles, (\d+) instructions, status (\d+)')
head = re.compile(r'^== round (\d+) tree \S+ config \[time-runs (.*)\]')
holds = []  # (workload, {build: {metric: [values]}})
for path in sys.argv[1:]:
    current = None
    for text in open(path):
        h = head.match(text)
        if h:
            args = h.group(2)
            corpus = 'SQLite' if 'sqlite3.c' in args else 'Lua' if 'lapi.c' in args else 'musl' if 'libc/musl' in args else args[:40]
            cores = re.search(r'--lanes (\d+)', args).group(1)
            current = ((corpus, int(cores)), {})
            holds.append(current)
            continue
        m = line.match(text)
        if m and current is not None:
            assert m.group(8) == '0', text
            d = current[1].setdefault(m.group(2), {'wall': [], 'cycles': [], 'instructions': []})
            d['wall'].append(float(m.group(4))); d['cycles'].append(int(m.group(6))); d['instructions'].append(int(m.group(7)))
def pct(a, b): return (a / b - 1) * 100
order = {'SQLite': 0, 'Lua': 1, 'musl': 2}
for workload in sorted({w for w, _ in holds}, key=lambda w: (w[1], order.get(w[0], 9))):
    mine = [d for w, d in holds if w == workload and d]
    print(f'{workload[0]}, {workload[1]} core(s): {len(mine)} holds, {sum(len(d["main"]["wall"]) for d in mine)} processes of main')
    for build in ['main', 'pr', 'main-again']:
        allw = [v for d in mine for v in d[build]['wall']]; allc = [v for d in mine for v in d[build]['cycles']]; alli = [v for d in mine for v in d[build]['instructions']]
        print(f'  {build:10s} pooled medians: {statistics.median(allw):.2f} ms wall, {statistics.median(allc):,.0f} user cycles, {statistics.median(alli):,.0f} instructions (min {min(alli):,} max {max(alli):,}), n={len(allw)}')
    for a, b in pairs:
        for metric in ['wall', 'cycles', 'instructions']:
            ratios = [pct(statistics.median(d[a][metric]), statistics.median(d[b][metric])) for d in mine]
            pooled = pct(statistics.median([v for d in mine for v in d[a][metric]]), statistics.median([v for d in mine for v in d[b][metric]]))
            print(f'  {a} vs {b} {metric}: pooled {pooled:+.3f}%; per hold median {statistics.median(ratios):+.3f}% [{min(ratios):+.3f}%, {max(ratios):+.3f}%]; {sum(r < 0 for r in ratios)} of {len(ratios)} holds below zero')
