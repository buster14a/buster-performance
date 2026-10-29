#!/usr/bin/env python3
# Item 2 against record A2: for each of A2's runs and campaign A4's, on 2 and 8 lanes with every lane, a lane's copy (the
# median of the units but sqlite3.c, then sqlite3.c's, in microseconds) and each unit's median change against one lane
# in the same process (the median over the units, its lowest and highest, and the units read faster on L lanes than on
# one); then each unit's change on 2, 3, 4 and 8 lanes by A2's branch and by final4. Reads grid3.py's summaries.
#   compareA2.py A2-SUMMARY.tsv A4-SUMMARY.tsv
import sys, csv, statistics, collections
def load(path):
    out = collections.defaultdict(dict)
    for r in csv.DictReader(open(path), delimiter='\t'):
        out[r['run']][(r['unit'].split('/')[-1], int(r['lanes']))] = r
    return out
a2, a4 = load(sys.argv[1]), load(sys.argv[2])
def summary(name, rows):
    for lanes in (2, 8):
        rs = [r for (u, l), r in rows.items() if l == lanes]
        if not rs:
            continue
        copies = [float(r['copy']) / 1000 for r in rs if r['unit'].split('/')[-1] != 'sqlite']
        sqlite = [float(r['copy']) / 1000 for r in rs if r['unit'].split('/')[-1] == 'sqlite']
        changes = [float(r['median']) for r in rs]
        faster = sum(c < 0 for c in changes)
        print('%-22s %d lanes: copy %4.0f us (%d units), sqlite3.c %4.0f us; change against one lane %+5.1f%% (%+.1f to %+.1f), %d of %d faster' % (
            name, lanes, statistics.median(copies), len(copies), sqlite[0] if sqlite else float('nan'), statistics.median(changes), min(changes), max(changes), faster, len(changes)))
for name in ('branch-every', 'branch-every-warm', 'main-every'):
    summary('A2 ' + name, a2.get(name, {}))
for name in ('final4-every', 'final4-every-warm', 'main3-every', 'main3-nothp-every'):
    summary('A4 ' + name, a4.get(name, {}))
units = sorted({u for (u, l) in a4.get('final4-every', {})}, key=lambda u: [k for k in a4['final4-every'] if k[0] == u][0][0])
print()
print('| Unit | ' + ' | '.join('A2 %d | A4 %d' % (l, l) for l in (2, 3, 4, 8)) + ' |')
print('| --- |' + ' ---: | ---: |' * 4)
order = []
for (u, l) in a4.get('final4-every', {}):
    if u not in order:
        order.append(u)
for u in order:
    cells = []
    for l in (2, 3, 4, 8):
        b = a2.get('branch-every', {}).get((u if u != 'sqlite' else 'sqlite', l))
        f = a4['final4-every'].get((u, l))
        cells.append('%s | %s' % ('%+.1f%%' % float(b['median']) if b else '-', '%+.1f%%' % float(f['median']) if f else '-'))
    print('| `%s` | %s |' % ('sqlite3.c' if u == 'sqlite' else u, ' | '.join(cells)))
