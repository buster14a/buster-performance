#!/usr/bin/env python3
# footprint.py HOT-FILE: of a hot.sh profile's samples in the node machine's functions (node_machine_* and node_shadow_*,
# into which a profile-guided build inlines the sweeps), the 64-byte code lines they fall on: how many lines hold 50, 80,
# 90, 95 and 99% of them, and by function, each one's share, its lines and the lines holding its 50 to 99%.
import sys, collections
counts = collections.Counter(); symbols = {}
for line in open(sys.argv[1]):
    fields = line.split()
    if len(fields) < 2 or not fields[1].startswith(('node_machine', 'node_shadow')):
        continue
    code = int(fields[0], 16) >> 6
    counts[code] += 1; symbols[code] = fields[1]
def marks(values):
    values = sorted(values, reverse=True); total = sum(values); found = {}; running = 0
    for i, v in enumerate(values):
        running += v
        for q in (0.5, 0.8, 0.9, 0.95, 0.99):
            if q not in found and running >= q * total:
                found[q] = i + 1
    return [found.get(q, 0) for q in (0.5, 0.8, 0.9, 0.95, 0.99)]
total = sum(counts.values())
print('samples %d on %d lines; lines holding 50/80/90/95/99%%: %s' % (total, len(counts), marks(counts.values())))
by = collections.defaultdict(list)
for code, v in counts.items():
    by[symbols[code]].append(v)
for name, values in sorted(by.items(), key=lambda item: -sum(item[1]))[:12]:
    print('%-32s %5.1f%% %4d lines, 50/80/90/95/99%%: %s' % (name, 100.0 * sum(values) / total, len(values), marks(values)))
