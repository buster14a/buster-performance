#!/usr/bin/env python3
# medians.py FILE...: over the given time files (rounds of one build, options and corpus), the median of each timed set's
# cycles and instructions a taken node, by the set's name, with each file's figures.
import sys, re, statistics, collections
cycles = collections.OrderedDict()
instructions = collections.OrderedDict()
for path in sys.argv[1:]:
    for line in open(path):
        m = re.search(r'time sweeps=(\S+) .*per-evaluated-node: cycles=([0-9.]+) instructions=([0-9.]+)', line)
        if m:
            cycles.setdefault(m.group(1), []).append(float(m.group(2)))
            instructions.setdefault(m.group(1), []).append(float(m.group(3)))
if not cycles:
    print('missing')
for name in cycles:
    print('%-8s cycles %6.1f  instructions %6.1f   (runs: %s)' % (name, statistics.median(cycles[name]), statistics.median(instructions[name]), ' '.join('%.1f' % c for c in cycles[name])))
