#!/usr/bin/env python3
# simulate.py DIR... [-- SEARCH_DIRECTORY...]: from traces of compiles without the asks (a trace a unit), what an ask at a
# component's k-th miss would do, for k = 1..5: each failed open is put to the search directory that is its longest
# prefix and the first component after it; a component with n misses is asked for at its k-th; one its directory lacks
# then spares n - k probes, and one it has spares none. Costs in cycles are the 9700X's (probecost): a failed open
# 1,265; an ask by an open 1,319 where the component is absent and 2,365 where it is there (an open and a close); by a
# stat 990 and 1,100.
import os, re, sys, glob
from collections import Counter
args = sys.argv[1:]
search = []
if '--' in args:
    i = args.index('--')
    search = [d.rstrip('/') for d in args[i + 1:]]
    args = args[:i]
search.sort(key=len, reverse=True)
FAILED, OPEN_ABSENT, OPEN_PRESENT, STAT_ABSENT, STAT_PRESENT = 1265, 1319, 2365, 990, 1100
for directory in args:
    units = sorted(glob.glob(directory + '/*.strace'))
    totals = {k: Counter() for k in range(1, 6)}
    failed_all = 0
    opens_all = 0
    under = 0
    for unit in units:
        misses = Counter()
        for line in open(unit, errors='replace'):
            m = re.search(r'openat\([A-Z_0-9]+, "([^"]*)", [A-Z_|]+\) = (-1 ENOENT|\d+)', line)
            if not m or 'O_DIRECTORY' in line or m.group(1).startswith(('/proc', '/sys/', '/dev/', '/etc')):
                continue
            opens_all += 1
            if not m.group(2).startswith('-1'):
                continue
            failed_all += 1
            path = m.group(1)
            for d in search:
                if path.startswith(d + '/'):
                    rest = path[len(d) + 1:]
                    if '/' in rest:
                        component = rest.split('/')[0]
                        if component not in ('.', '..', ''):
                            misses[(d, component)] += 1
                            under += 1
                    break
        for k in range(1, 6):
            t = totals[k]
            for (d, component), n in misses.items():
                if n >= k:
                    present = os.path.isdir(d + '/' + component)
                    t['asks_present' if present else 'asks_absent'] += 1
                    if not present:
                        t['spared'] += n - k
    print(f'{directory}: {len(units)} units, {opens_all} opens, {failed_all} failed, {under} of them under a first component of a search directory')
    for k in range(1, 6):
        t = totals[k]
        by_open = t['spared'] * FAILED - t['asks_absent'] * OPEN_ABSENT - t['asks_present'] * OPEN_PRESENT
        by_stat = t['spared'] * FAILED - t['asks_absent'] * STAT_ABSENT - t['asks_present'] * STAT_PRESENT
        print(f'  asked at miss {k}: {t["asks_absent"]} asks of a component that is absent, {t["asks_present"]} of one that is there, {t["spared"]} probes spared; '
              f'net cycles a unit: {by_open / len(units):+.0f} by an open, {by_stat / len(units):+.0f} by a stat')
