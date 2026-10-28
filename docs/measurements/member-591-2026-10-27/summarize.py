#!/usr/bin/env python3
# summarize.py OUT: medians per tree and mode of task-clock, cycles:u and instructions:u, and each tree's paired
# difference from the first tree's, per round.
import sys, glob, os, statistics, re
out = sys.argv[1]
runs = {}
for path in glob.glob(os.path.join(out, 'r*-*.csv')):
    name = os.path.basename(path)[:-4]
    m = re.match(r'r(\d+)-(.+)-(c|fsyntax)$', name)
    if not m:
        continue
    round_, tree, mode = int(m.group(1)), m.group(2), m.group(3)
    values = {}
    for line in open(path):
        parts = line.strip().split(',')
        if len(parts) > 3 and parts[0] and not line.startswith('#'):
            try:
                values[parts[2]] = float(parts[0])
            except ValueError:
                pass
    runs[(round_, tree, mode)] = values
trees = sorted({k[1] for k in runs}, key=lambda t: (not t.startswith('main'), t))
for mode in ['c', 'fsyntax']:
    print('==', mode)
    for event in ['task-clock', 'cycles:u', 'instructions:u']:
        base = trees[0]
        for tree in trees:
            values = [runs[k].get(event) for k in runs if k[1] == tree and k[2] == mode and runs[k].get(event) is not None]
            diffs = []
            for round_ in range(1, 9):
                a = runs.get((round_, base, mode), {}).get(event)
                b = runs.get((round_, tree, mode), {}).get(event)
                if a and b:
                    diffs.append((b - a) / a * 100)
            if values:
                print(f'  {event:15} {tree:12} median {statistics.median(values):14.3f}  paired {statistics.median(diffs) if diffs else 0:+.2f}% (min {min(diffs) if diffs else 0:+.2f}, max {max(diffs) if diffs else 0:+.2f})')
