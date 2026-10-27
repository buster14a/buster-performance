#!/usr/bin/env python3
# #442: per-file deltas of a stage's per-round values (median over rounds) between two trees, with the file's counts.
import sys, re, glob, statistics, collections
d, a, b, key = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
data = collections.defaultdict(lambda: collections.defaultdict(list)); info = {}
for p in glob.glob(f'{d}/round-*-*.txt'):
    t = re.search(r'round-\d+-(\w+)\.txt$', p).group(1)
    for line in open(p):
        if 'file=' in line and ' ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:]); n = f['file'].rsplit('/', 1)[-1]
            data[t][n].append(float(f[key])); info[n] = f
rows = []
for n in data[a]:
    if n in data[b]:
        x, y = statistics.median(data[a][n]), statistics.median(data[b][n])
        rows.append((y - x, x, y, n, int(info[n]['tokens']), info[n]['functions'], info[n]['objects'], info[n]['symbols']))
rows.sort()
tot = sum(r[0] for r in rows)
print(f'{key}: sum delta {tot:,.0f} ns over {len(rows)} files, sum {a} {sum(r[1] for r in rows):,.0f}')
# by token buckets
buckets = collections.defaultdict(lambda: [0, 0.0, 0.0])
for r in rows:
    k = 'small(<300 tokens)' if r[4] < 300 else 'mid(<3000)' if r[4] < 3000 else 'large(>=3000)'
    buckets[k][0] += 1; buckets[k][1] += r[0]; buckets[k][2] += r[1]
for k, v in sorted(buckets.items()): print(f'  {k}: files={v[0]} delta={v[1]:,.0f} ({100*v[1]/v[2]:+.2f}% of {a}) per-file {v[1]/v[0]:,.0f}')
for r in rows[:5] + rows[-8:]: print(f'  {r[3]} d={r[0]:+,.0f} {a}={r[1]:,.0f} {b}={r[2]:,.0f} tokens={r[4]} fn={r[5]} obj={r[6]} sym={r[7]}')
