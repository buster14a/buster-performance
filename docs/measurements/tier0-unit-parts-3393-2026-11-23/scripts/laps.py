# laps.py MAP DIR [MIN_US]: medians of each lap over DIR/stages-*.txt, in microseconds, with the map's source line.
import glob, sys, statistics, collections
m = {}
for l in open(sys.argv[1]):
    p = l.rstrip('\n').split(' ', 2)
    m[int(p[0])] = p[1] + ' ' + (p[2] if len(p) > 2 else '')
runs = collections.defaultdict(list); hits = {}
for f in sorted(glob.glob(sys.argv[2] + '/stages-*.txt')):
    for l in open(f):
        if l.startswith('xlap\t'):
            _, n, t, h = l.split('\t'); runs[int(n)].append(int(t)); hits[int(n)] = int(h)
mn = float(sys.argv[3]) if len(sys.argv) > 3 else 0
tot = 0
for n in sorted(runs):
    us = statistics.median(runs[n]) / 3792.8
    tot += us
    if us >= mn: print('%4d %8.1f %6d  %s' % (n, us, hits[n], m.get(n, '?')))
print('sum', round(tot, 1))
