#!/usr/bin/env python3
# A diagnostic's log (3-runs.sh's format, every run on 8 lanes with every lane) as a Markdown table: for each unit, each
# tree's readings on one lane and on eight (the whole reading, ns/token) and on eight its walks and its lanes' span
# (ns/token) and copy (µs a lane), the medians over the rounds; then each tree's readings against the last tree's.
#   difftable.py LOG TREE...
import sys, re, collections, statistics
log, trees = sys.argv[1], sys.argv[2:]
rows = collections.defaultdict(list)
head = None
order = []
for line in open(log):
    m = re.match(r'== round (\d+) (\S+) (\S+) lanes (\d+)', line)
    if m:
        head = (m.group(3), m.group(2).replace('-every', ''))
        if head[0] not in order:
            order.append(head[0])
        continue
    m = re.search(r'lanes=(\d+) active=\d+ copies=\d+ whole=([\d.]+) top=[\d.]+ environment=[\d.]+ walks=([\d.]+) positions=([\d.]+) lanes_span=([\d.]+) .* copy=(\d+)', line)
    if m and head:
        rows[(head[0], head[1], int(m.group(1)))].append((float(m.group(2)), float(m.group(3)), float(m.group(5)), int(m.group(6)) / 1000))
def med(u, t, lanes, i):
    v = rows[(u, t, lanes)]
    return statistics.median(x[i] for x in v) if v else float('nan')
print('| Unit | ' + ' | '.join('`%s`: 1 lane, 8 lanes, walks, span, copy' % t for t in trees) + ' |')
print('| --- |' + ' --- |' * len(trees))
for u in order:
    cells = []
    for t in trees:
        cells.append('%.2f, %.2f, %.2f, %.2f, %.0f' % (med(u, t, 1, 0), med(u, t, 8, 0), med(u, t, 8, 1), med(u, t, 8, 2), med(u, t, 8, 3)))
    print('| `%s` | %s |' % (u if u != 'sqlite' else 'sqlite3.c', ' | '.join(cells)))
print()
base = trees[-1]
for t in trees[:-1]:
    for lanes in (1, 8):
        d = ['%s %+.1f%%' % (u, (med(u, t, lanes, 0) / med(u, base, lanes, 0) - 1) * 100) for u in order]
        print('%s against %s on %d lane(s): %s' % (t, base, lanes, ', '.join(d)))
rounds = sorted(set(len(v) for v in rows.values()))
print('rounds per cell: %s' % rounds)
