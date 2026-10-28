#!/usr/bin/env python3
# Before and after (campaign B): each unit's reading on 8 lanes by each tree's rule against its reading on one lane in
# the same process, the median change over the rounds with its lowest and highest, the lanes the rule gave, and the
# medians of the readings on 8 lanes (ns/token).
#   compare.py logB.txt [logCT.txt]
import sys, statistics, collections
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from grid import read, summarize
rows = read([sys.argv[1]])
s = summarize(rows)
by = collections.OrderedDict()
for g in s:
    by.setdefault(g['unit'], {})[g['run']] = g
print('| Unit | Bodies | Main\'s lanes | Main, 8 against 1 | The rule\'s lanes | The rule, 8 against 1 | Main on 8 | The rule on 8 |')
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for unit, runs in by.items():
    m = runs.get('main'); f = runs.get('final')
    if m is None or f is None:
        continue
    print('| %s | %d | %d | %+.1f%% (%+.1f to %+.1f) | %d | %+.1f%% (%+.1f to %+.1f) | %.2f | %.2f |' % (unit.split('/')[-1], m['bodies'], m['active'], m['median'], m['low'], m['high'],
          f['active'], f['median'], f['low'], f['high'], m['many'], f['many']))
worst = max(g['median'] for g in s if g['run'] == 'final')
print()
print('final: worst median 8-vs-1 %+.2f%%; units %d' % (worst, sum(1 for g in s if g['run'] == 'final')))
if len(sys.argv) > 2:
    ct = summarize(read([sys.argv[2]]))
    for run in ('main', 'final'):
        gs = [g for g in ct if g['run'] == run]
        over2 = [g for g in gs if g['median'] > 2.0]
        over5 = [g for g in gs if g['median'] > 5.0]
        multi = [g for g in gs if g['active'] > 1]
        print('c-testsuite %s: programs %d, on more than one lane %d, 8 lanes more than 2%% slower than one %d, more than 5%% %d, worst %+.1f%% (%s)' % (
            run, len(gs), len(multi), len(over2), len(over5), max(g['median'] for g in gs), max(gs, key=lambda g: g['median'])['unit']))
