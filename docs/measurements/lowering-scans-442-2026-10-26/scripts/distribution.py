#!/usr/bin/env python3
# #442: the per-file distribution of a stage's change between two trees: each file's median over rounds of its per-run
# value (a run's median, or minimum, over its passes), the ratio b/a per file, and its quantiles, for all files and by
# token count. Usage: distribution.py ROUNDS_DIR A B KEY
import sys, re, glob, statistics, collections
d, a, b, key = sys.argv[1:5]
data = collections.defaultdict(lambda: collections.defaultdict(list)); tokens = {}
for p in glob.glob(f'{d}/round-*-*.txt'):
    t = re.search(r'round-\d+-(\w+)\.txt$', p).group(1)
    for line in open(p):
        if 'file=' in line and ' ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:]); n = f['file'].rsplit('/', 1)[-1]
            data[t][n].append(float(f[key])); tokens[n] = int(f['tokens'])
def q(v, p): v = sorted(v); return v[min(len(v) - 1, int(p * (len(v) - 1) + 0.5))]
groups = {'all': lambda n: True, 'tokens<300': lambda n: tokens[n] < 300, '300<=tokens<3000': lambda n: 300 <= tokens[n] < 3000, 'tokens>=3000': lambda n: tokens[n] >= 3000}
print(f'{key}: {b} against {a}, per file (median over rounds), ratio quantiles')
for g, keep in groups.items():
    files = [n for n in data[a] if n in data[b] and keep(n)]
    r = [statistics.median(data[b][n]) / statistics.median(data[a][n]) - 1 for n in files]
    sa = sum(statistics.median(data[a][n]) for n in files); sb = sum(statistics.median(data[b][n]) for n in files)
    print(f'  {g:18s} files={len(files):3d} p10={100*q(r,.1):+6.1f}% p25={100*q(r,.25):+6.1f}% p50={100*q(r,.5):+6.1f}% p75={100*q(r,.75):+6.1f}% p90={100*q(r,.9):+6.1f}%'
          f'  sum {a}={sa:,.0f} {b}={sb:,.0f} ({100*(sb/sa-1):+.1f}%, {(sb-sa)/len(files):+,.0f} ns/file)')
