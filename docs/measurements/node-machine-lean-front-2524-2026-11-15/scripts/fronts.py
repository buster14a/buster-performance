#!/usr/bin/env python3
# fronts.py FILE...: over the given files (runs of one build, options and corpus), the medians of the walk's parts' ticks
# and of the front's, in ticks and in ms at the TSC's 3792.9 MHz, with the front's counts from the first file.
import sys, re, statistics
names = ['classes', 'prepare', 'actions', 'visits']
walk = {n: [] for n in names}
front = []
prepare = {}
counts = []
for path in sys.argv[1:]:
    for line in open(path):
        m = re.search(r'node-shadow: walk ticks classes=(\d+) prepare=(\d+) actions=(\d+) visits=(\d+)', line)
        if m:
            for n, v in zip(names, m.groups()):
                walk[n].append(int(v))
        m = re.search(r'node-shadow: front ticks=(\d+)', line)
        if m:
            front.append(int(m.group(1)))
        m = re.search(r'node-shadow: walk prepare ticks compact=(\d+) identifiers=(\d+) literals=(\d+)', line)
        if m:
            for n, v in zip(['compact', 'identifiers', 'literals'], m.groups()):
                prepare.setdefault(n, []).append(int(v))
        if path == sys.argv[1] and re.search(r'node-shadow: front (after|before|taken|operands|left sizeof|structure|not run)', line):
            counts.append(line.rstrip())
if not walk['actions']:
    print('missing')
    sys.exit(1)
mhz = 3792.9
def show(name, values):
    median = statistics.median(values)
    print('%-8s %12d ticks  %7.3f ms   (runs: %s)' % (name, median, median / mhz / 1000, ' '.join('%.2f' % (v / mhz / 1000) for v in values)))
for n in names:
    show(n, walk[n])
show('walk', [sum(walk[n][i] for n in names) for i in range(len(walk['actions']))])
if front:
    show('front', front)
for n in ['compact', 'identifiers', 'literals']:
    if n in prepare:
        show(n, prepare[n])
for line in counts:
    print(line)
