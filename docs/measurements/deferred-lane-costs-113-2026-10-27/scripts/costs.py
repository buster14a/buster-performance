#!/usr/bin/env python3
# What a lane costs, from a grid's summary (grid.py): for some units, a lane's copy of the reader on 2 and 8 lanes by
# BEFORE (arenas reserved inside the lanes), AFTER (reserved before the lanes start) and AFTER's later readings (WARM),
# AFTER's arenas and its wake-up, in microseconds (medians over the rounds); then the medians over the units but
# sqlite3.c, and sqlite3.c's.
#   costs.py BEFORE AFTER WARM < summary.tsv
import sys, csv, statistics, collections
before, after, warm = sys.argv[1], sys.argv[2], sys.argv[3]
rows = list(csv.DictReader(sys.stdin, delimiter='\t'))
by = collections.defaultdict(dict)
for r in rows:
    by[r['unit'].split('/')[-1]][(r['run'], r['lanes'])] = r
units = ['b16x19.c', 'h16x1.c', 'h16x19.c', 'h16x154.c', 'x16x19.c', 'l16x38f384.c', '00204.c', 'sqlite']
us = lambda v: '%.0f' % (float(v) / 1000)
us1 = lambda v: '%.1f' % (float(v) / 1000)
print('| Unit | Top level\'s tokens | `%s`, 2 lanes | 8 lanes | `%s`, 2 lanes | 8 lanes | `%s`, 2 lanes | 8 lanes | The arenas, 2 lanes | 8 lanes | The wake-up, 2 lanes | 8 lanes |' % (before, after, warm))
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for u in units:
    d = by[u]
    b2, b8 = d[(before, '2')], d[(before, '8')]
    a2, a8 = d[(after, '2')], d[(after, '8')]
    w2, w8 = d[(warm, '2')], d[(warm, '8')]
    name = 'sqlite3.c' if u == 'sqlite' else u
    print('| `%s` | %d | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |' % (name, int(a2['tokens']) - int(a2['body_tokens']), us(b2['copy']), us(b8['copy']),
          us(a2['copy']), us(a8['copy']), us(w2['copy']), us(w8['copy']), us1(a2['arenas']), us1(a8['arenas']), us1(a2['wake']), us1(a8['wake'])))
print()
for run in (before, after, warm):
    for lanes in ('2', '8'):
        rs = [d[(run, lanes)] for u, d in by.items() if (run, lanes) in d]
        others = [float(r['copy']) / 1000 for r in rs if not r['unit'].endswith('sqlite')]
        sqlite = [float(r['copy']) / 1000 for r in rs if r['unit'].endswith('sqlite')]
        arenas = [float(r['arenas']) / 1000 for r in rs]
        wake = [float(r['wake']) / 1000 for r in rs if not r['unit'].endswith('sqlite')]
        print('%s on %s lanes: a copy %.0f us (median of %d units but sqlite3.c), sqlite3.c %s us; arenas %.1f to %.1f us; wake-up median %.1f us' % (
            run, lanes, statistics.median(others), len(others), '%.0f' % sqlite[0] if sqlite else '-', min(arenas), max(arenas), statistics.median(wake)))
