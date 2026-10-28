#!/usr/bin/env python3
# Before and after, as compare.py, for the 2026-10-28 runs: each unit's reading on 8 lanes by each tree's rule against
# its reading on one lane in the same process, the median change over the rounds with its lowest and highest, the lanes
# the rule gave, and the medians of the readings on 8 lanes (ns/token), for the runs named BEFORE and AFTER. With a
# c-testsuite log, its programs' changes by size and how many each rule read on more than one lane.
#   compare2.py BEFORE AFTER log [c-testsuite log]
import sys, statistics, collections
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from grid import read, summarize
before, after = sys.argv[1], sys.argv[2]
s = summarize(read([sys.argv[3]]))
by = collections.OrderedDict()
for g in s:
    by.setdefault(g['unit'], {})[g['run']] = g
print('| Unit | Bodies | %s\'s lanes | %s, 8 against 1 | %s\'s lanes | %s, 8 against 1 | %s on 8 | %s on 8 | %s against %s on 8 |' % (
    before, before, after, after, before, after, after, before))
print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for unit, runs in by.items():
    b = runs.get(before)
    a = runs.get(after)
    if b is None or a is None:
        continue
    print('| %s | %d | %d | %+.1f%% (%+.1f to %+.1f) | %d | %+.1f%% (%+.1f to %+.1f) | %.2f | %.2f | %+.1f%% |' % (
        unit.split('/')[-1], b['bodies'], b['active'], b['median'], b['low'], b['high'], a['active'], a['median'], a['low'], a['high'], b['many'], a['many'],
        (a['many'] / b['many'] - 1) * 100))
for run in (before, after):
    gs = [g for g in s if g['run'] == run]
    print('%s: worst median 8 against 1 %+.2f%% (%s); rounds %s; units %d' % (run, max(g['median'] for g in gs), max(gs, key=lambda g: g['median'])['unit'],
                                                                         sorted(set(g['rounds'] for g in gs)), len(gs)))
if len(sys.argv) > 4:
    ct = summarize(read([sys.argv[4]]))
    for run in (before, after):
        gs = [g for g in ct if g['run'] == run]
        multi = [g for g in gs if g['active'] > 1]
        print('c-testsuite %s: programs %d, rounds %s, on more than one lane %d %s' % (run, len(gs), sorted(set(g['rounds'] for g in gs)), len(multi),
                                                                                  ' '.join('%s:%d:%+.1f%%' % (g['unit'], g['active'], g['median']) for g in multi)))
        for low, high, label in ((0, 100, 'under 100 tokens'), (100, 1000, '100 to 999'), (1000, 1 << 62, '1,000 or more')):
            band = [g['median'] for g in gs if low <= g['tokens'] < high]
            if band:
                print('  %s: %d programs, %+.1f to %+.1f%%, mean %+.2f%%, standard deviation %.2f%%, more than 2%% slower %d, more than 5%% %d' % (
                    label, len(band), min(band), max(band), statistics.mean(band), statistics.pstdev(band), sum(1 for x in band if x > 2.0),
                    sum(1 for x in band if x > 5.0)))
