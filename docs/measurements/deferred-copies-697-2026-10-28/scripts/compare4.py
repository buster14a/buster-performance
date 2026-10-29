#!/usr/bin/env python3
# The grid's runs against each other: for each unit, on 2 and 8 lanes with every lane, each run's median change against
# one lane, its reading on L lanes and on one lane (ns/token), and final4's readings against main3's and main3-nothp's.
#   compare4.py < summary.tsv
import sys, csv, statistics, collections
rows = list(csv.DictReader(sys.stdin, delimiter='\t'))
by = collections.defaultdict(dict)
order = []
for r in rows:
    u = r['unit'].split('/')[-1]
    if u not in order:
        order.append(u)
    by[u][(r['run'], r['lanes'])] = r
for lanes in ('2', '8'):
    print('== %s lanes: change against one lane (median), reading on %s lanes and on one (ns/token); final4 against main3 and main3-nothp' % (lanes, lanes))
    ratios_main = []; ratios_nothp = []; ratios_main1 = []; ratios_nothp1 = []
    for u in order:
        d = by[u]
        f, m, n = d.get(('final4-every', lanes)), d.get(('main3-every', lanes)), d.get(('main3-nothp-every', lanes))
        if not (f and m and n):
            continue
        fm = float(f['many']) / float(m['many']) - 1; fn = float(f['many']) / float(n['many']) - 1
        fm1 = float(f['one']) / float(m['one']) - 1; fn1 = float(f['one']) / float(n['one']) - 1
        ratios_main.append(fm); ratios_nothp.append(fn); ratios_main1.append(fm1); ratios_nothp1.append(fn1)
        print('  %-20s final4 %+6.1f%% %7.2f %7.2f | main3 %+6.1f%% %7.2f %7.2f | nothp %+6.1f%% %7.2f %7.2f | on %s: %+5.1f%% %+5.1f%%, on 1: %+5.1f%% %+5.1f%%' % (
            u, float(f['median']), float(f['many']), float(f['one']), float(m['median']), float(m['many']), float(m['one']),
            float(n['median']), float(n['many']), float(n['one']), lanes, fm * 100, fn * 100, fm1 * 100, fn1 * 100))
    q = lambda v: '%+.1f%% (%+.1f to %+.1f)' % (statistics.median(v) * 100, min(v) * 100, max(v) * 100)
    print('  final4 against main3 on %s lanes %s, on one %s; against main3-nothp on %s %s, on one %s' % (lanes, q(ratios_main), q(ratios_main1), lanes, q(ratios_nothp), q(ratios_nothp1)))
