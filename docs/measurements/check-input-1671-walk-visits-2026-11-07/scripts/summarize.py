import sys, glob, statistics, re, os
out = sys.argv[1]; labels = sys.argv[2:]
for x in labels:
    vals = {}
    for f in sorted(glob.glob(f'{out}/stat-{x}-*.csv')):
        for line in open(f):
            p = line.strip().split(',')
            if len(p) > 3 and p[0] and p[0][0].isdigit():
                vals.setdefault(p[2], []).append(float(p[0]))
    print(x, {k: f'{statistics.median(v):,.1f} (n={len(v)})' for k, v in vals.items()})
