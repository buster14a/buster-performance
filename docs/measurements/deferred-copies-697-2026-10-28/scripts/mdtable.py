#!/usr/bin/env python3
# A compact Markdown table of a diagnostic's log: each unit's whole reading on one lane and on eight (ns/token), and on
# eight its walks (summed over the lanes) and a lane's copy (µs), per tree, the medians over the rounds.
#   mdtable.py LOG FIELDS TREE... (FIELDS: one, eight, walks, copy, comma-separated)
import sys, re, collections, statistics
log, fields, trees = sys.argv[1], sys.argv[2].split(','), sys.argv[3:]
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
    if line.startswith('== '):
        # Another heading (diag9's profile of final4): its run is no round's.
        head = None
        continue
    m = re.search(r'lanes=(\d+) active=\d+ copies=\d+ whole=([\d.]+) top=[\d.]+ environment=[\d.]+ walks=([\d.]+) positions=([\d.]+) lanes_span=([\d.]+) .* copy=(\d+)', line)
    if m and head:
        rows[(head[0], head[1], int(m.group(1)))].append((float(m.group(2)), float(m.group(3)), int(m.group(6)) / 1000))
def med(u, t, lanes, i):
    v = rows[(u, t, lanes)]
    return statistics.median(x[i] for x in v)
names = {'one': 'one lane', 'eight': 'eight lanes', 'walks': 'walks on eight', 'copy': 'copy on eight (µs)'}
cols = ['`%s`, %s' % (t, names[f]) for t in trees for f in fields]
print('| Unit | ' + ' | '.join(cols) + ' |')
print('| --- |' + ' ---: |' * len(cols))
for u in order:
    cells = []
    for t in trees:
        for f in fields:
            v = med(u, t, 1, 0) if f == 'one' else med(u, t, 8, 0) if f == 'eight' else med(u, t, 8, 1) if f == 'walks' else med(u, t, 8, 2)
            cells.append('%.0f' % v if f == 'copy' else '%.2f' % v)
    print('| `%s` | %s |' % ('sqlite3.c' if u == 'sqlite' else u + '.c', ' | '.join(cells)))
