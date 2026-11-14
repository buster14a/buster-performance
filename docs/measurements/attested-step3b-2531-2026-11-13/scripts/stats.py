#!/usr/bin/env python3
# stats.py DIR PREFIX...: medians of perf stat CSVs DIR/stat-PREFIX-WAY-ROUND.csv by way: cycles of both modes, user
# cycles, task-clock ms, page faults; and the ratios to the first way.
import sys, os, re, statistics, collections
d = sys.argv[1]
for prefix in sys.argv[2:]:
    ways = collections.defaultdict(lambda: collections.defaultdict(list))
    for name in os.listdir(d):
        m = re.match(re.escape('stat-' + prefix) + r'-([a-z0-9]+)-(\d+)\.csv$', name)
        if not m:
            continue
        values = {}
        for line in open(os.path.join(d, name)):
            parts = line.strip().split(',')
            if len(parts) > 3 and parts[0] not in ('', '<not counted>'):
                try:
                    values[parts[2]] = float(parts[0])
                except ValueError:
                    pass
        cycles = values.get('cycles:u', 0) + values.get('cycles:k', 0)
        ways[m.group(1)]['cycles'].append(cycles)
        ways[m.group(1)]['user'].append(values.get('cycles:u', 0))
        ways[m.group(1)]['kernel'].append(values.get('cycles:k', 0))
        ways[m.group(1)]['ms'].append(values.get('task-clock', 0))
        ways[m.group(1)]['faults'].append(values.get('page-faults', 0))
        ways[m.group(1)]['instructions'].append(values.get('instructions:u', 0))
    # The wall times, where the step wrote them: DIR/wall-PREFIX-WAY-ROUND.txt, ms.
    for name in os.listdir(d):
        m = re.match(re.escape('wall-' + prefix) + r'-([a-z0-9]+)-(\d+)\.txt$', name)
        if m and m.group(1) in ways:
            ways[m.group(1)]['wall'].append(float(open(os.path.join(d, name)).read()))
    order = [w for w in ('baseoff', 'base', 'off', 'on', 'head', 'noint') if w in ways] + sorted(w for w in ways if w not in ('baseoff', 'base', 'off', 'on', 'head', 'noint'))
    first = None
    for w in order:
        med = {k: statistics.median(v) for k, v in ways[w].items()}
        first = first or med
        print(f"{prefix} {w:5} n={len(ways[w]['cycles'])} cycles={med['cycles']/1e6:9.1f}M user={med['user']/1e6:9.1f}M kernel={med['kernel']/1e6:8.1f}M "
              f"ms={med['ms']:8.1f} faults={med['faults']:8.0f} instr={med['instructions']/1e6:9.1f}M  x{first['cycles']/med['cycles']:.3f} (ms x{first['ms']/med['ms']:.3f})"
              + (f" wall={med['wall']:7.1f} ms n={len(ways[w]['wall'])} x{first['wall']/med['wall']:.3f}" if 'wall' in med and 'wall' in first else ''))
