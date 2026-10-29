#!/usr/bin/env python3
# Record A2's costs.py for campaign A4: a lane's copy of the reader on 2 and 8 lanes by main3, main3-nothp, final4 and
# final4's later readings, for A2's units, in microseconds (medians over the rounds); then each run's medians over the
# units but sqlite3.c, and sqlite3.c's, with the copy's share of the wake-up and arenas. Reads grid3.py's summary.
#   costs3.py < summary.tsv
import sys, csv, statistics, collections
runs = ['main3-every', 'main3-nothp-every', 'final4-every', 'final4-every-warm']
rows = list(csv.DictReader(sys.stdin, delimiter='\t'))
by = collections.defaultdict(dict)
for r in rows:
    by[r['unit'].split('/')[-1]][(r['run'], r['lanes'])] = r
units = ['b16x19.c', 'h16x1.c', 'h16x19.c', 'h16x154.c', 'x16x19.c', 'l16x38f384.c', '00204.c', 'sqlite']
us = lambda v: '%.0f' % (float(v) / 1000)
print('| Unit | Top level\'s tokens | ' + ' | '.join('`%s`, 2 lanes | 8 lanes' % r for r in runs) + ' |')
print('| --- | ---: |' + ' ---: | ---: |' * len(runs))
for u in units:
    d = by[u]
    a = d[('final4-every', '2')]
    name = 'sqlite3.c' if u == 'sqlite' else u
    print('| `%s` | %d | %s |' % (name, int(a['tokens']) - int(a['body_tokens']), ' | '.join('%s | %s' % (us(d[(r, '2')]['copy']), us(d[(r, '8')]['copy'])) for r in runs)))
print()
for run in runs:
    for lanes in ('2', '8'):
        rs = [d[(run, lanes)] for u, d in by.items() if (run, lanes) in d]
        others = [float(r['copy']) / 1000 for r in rs if not r['unit'].endswith('sqlite')]
        sqlite = [float(r['copy']) / 1000 for r in rs if r['unit'].endswith('sqlite')]
        arenas = [float(r['arenas']) / 1000 for r in rs]
        wake = [float(r['wake']) / 1000 for r in rs if not r['unit'].endswith('sqlite')]
        print('%s on %s lanes: a copy %.0f us (median of %d units but sqlite3.c), sqlite3.c %s us; arenas %.1f to %.1f us; wake-up median %.1f us' % (
            run, lanes, statistics.median(others), len(others), '%.0f' % sqlite[0] if sqlite else '-', min(arenas), max(arenas), statistics.median(wake)))
