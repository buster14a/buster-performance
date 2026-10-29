#!/usr/bin/env python3
# Campaign CT4: c-testsuite's programs by main3's rule and final4's (grid3.py's summary of 4-logCT.txt): the programs
# each rule gives more than one lane, with their changes; for those on one lane, whose two readings are the same work,
# how far apart the two came by the program's tokens (lowest, highest and standard deviation of the medians); and
# final4's one-lane reading against main3's by how long main3's took (the median and its spread).
#   ct4.py < summary.tsv
import sys, csv, statistics, collections
rows = list(csv.DictReader(sys.stdin, delimiter='\t'))
by = collections.defaultdict(dict)
for r in rows:
    by[r['unit']][r['run']] = r
units = [u for u in by if 'main3' in by[u] and 'final4' in by[u]]
print('programs: %d' % len(units))
for run in ('main3', 'final4'):
    more = [(u, by[u][run]) for u in units if by[u][run]['active'] != '1']
    print('%s: %d on more than one lane: %s' % (run, len(more), ', '.join('%s (%s lanes, %+.1f%%)' % (u, r['active'], float(r['median'])) for u, r in more)))
bins = [('1,000 tokens or more', 1000, 10 ** 9), ('100 to 999', 100, 1000), ('under 100', 0, 100)]
for run in ('main3', 'final4'):
    for name, low, high in bins:
        v = [float(by[u][run]['median']) for u in units if by[u][run]['active'] == '1' and low <= int(by[u][run]['tokens']) < high]
        if v:
            print('%s, one lane, %s: %d programs, %+.1f to %+.1f%%, standard deviation %.2f%%' % (run, name, len(v), min(v), max(v), statistics.pstdev(v)))
times = [('under 50 us', 0, 50), ('50 to 200 us', 50, 200), ('200 us to 1 ms', 200, 1000), ('1 ms or more', 1000, 10 ** 9)]
for name, low, high in times:
    v = []
    for u in units:
        m, f = by[u]['main3'], by[u]['final4']
        us = float(m['one']) * int(m['tokens']) / 1000
        if low <= us < high:
            v.append((float(f['one']) / float(m['one']) - 1) * 100)
    if v:
        print('final4 against main3 on one lane, main3 %s: %d programs, median %+.1f%% (%+.1f to %+.1f)' % (name, len(v), statistics.median(v), min(v), max(v)))
