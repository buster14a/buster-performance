#!/usr/bin/env python3
# #442: each synthetic unit's floor (least per-run minimum over the rounds) per tree, total and by stage, against the
# first tree named. Usage: synthetic_floor.py ROUNDS_DIR TREE...
import sys, glob, re, collections
d, trees = sys.argv[1], sys.argv[2:]
keys = ('min_ns', 'min_select', 'min_emit', 'min_publish', 'min_object')
floor = collections.defaultdict(dict); info = {}
for p in glob.glob(d + '/round-*-*.txt'):
    t = re.search(r'round-\d+-(\w+)\.txt$', p).group(1)
    for line in open(p):
        if 'file=' in line and ' ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:]); n = f['file'].rsplit('/', 1)[-1]
            v = [float(f[k]) for k in keys]; o = floor[t].get(n)
            floor[t][n] = [min(a, b) for a, b in zip(v, o)] if o else v
            info[(t, n)] = (f['tokens'], f['functions'], f['objects'], f['symbols'], f['object_bytes'])
print('floor (least per-run minimum over the rounds), ns: total (against ' + trees[0] + ') / select / emit / publish / object')
for n in sorted(floor[trees[0]]):
    print(n, 'tokens=%s' % info[(trees[0], n)][0])
    for t in trees:
        v = floor[t][n]; b = floor[trees[0]][n][0]
        print(f'  {t:6s} {v[0]:11,.0f} ({100*(v[0]/b-1):+6.1f}%) {v[1]:9,.0f} {v[2]:11,.0f} {v[3]:9,.0f} {v[4]:9,.0f}  functions={info[(t,n)][1]} objects={info[(t,n)][2]} symbols={info[(t,n)][3]} bytes={info[(t,n)][4]}')
