# units.py logs/units.tsv: musl's units below 8,000 preprocessed bytes by size bin, pooled user cycles and instructions
# of each build against no bit's; then, for each bit, the units where it reads above both no-bit runs, below both, and
# with more instructions than no bit.
import sys
rows = [l.rstrip('\n').split('\t') for l in open(sys.argv[1])]
bins = [(0, 1000), (1000, 2000), (2000, 4000), (4000, 8000), (0, 8000)]
builds = ('none', 'bit0', 'bit1', 'both', 'none-again')
data = []
for r in rows:
    if len(r) < 4 or r[2] != '0':
        continue
    w = r[3].split()
    d = {w[i]: (int(w[i + 1]), int(w[i + 2])) for i in range(0, len(w), 3)}
    if all(b in d for b in builds):
        data.append((int(r[1]), d))
print('units', len(data))
for lo, hi in bins:
    sel = [d for b, d in data if lo <= b < hi]
    tot = {b: sum(d[b][0] for d in sel) for b in builds}
    ins = {b: sum(d[b][1] for d in sel) for b in builds}
    print(f'{lo}-{hi} n={len(sel)} ' + ' '.join(f'{b} {100 * (tot[b] - tot["none"]) / tot["none"]:+.2f}%' for b in builds[1:]) +
          ' | instructions ' + ' '.join(f'{b} {100 * (ins[b] - ins["none"]) / ins["none"]:+.2f}%' for b in builds[1:]))
for b in ('bit0', 'bit1', 'both'):
    above = sum(1 for _, d in data if d[b][0] > max(d['none'][0], d['none-again'][0]))
    below = sum(1 for _, d in data if d[b][0] < min(d['none'][0], d['none-again'][0]))
    more = sum(1 for _, d in data if d[b][1] > d['none'][1])
    fewer = sum(1 for _, d in data if d[b][1] < d['none'][1])
    print(b, 'above both', above, 'below both', below, 'more instructions', more, 'fewer', fewer)
# Against the two no-bit runs' mean: no bit's instructions read ~165 more than no bit again's in the median unit (the
# runs' own spread), so a bit's instruction deltas are taken against their mean.
import statistics
for b in ('bit0', 'bit1'):
    deltas = [d[b][1] - (d['none'][1] + d['none-again'][1]) / 2 for _, d in data]
    spread = [d['none-again'][1] - d['none'][1] for _, d in data]
    print(b, 'instructions against the no-bit mean: median', statistics.median(deltas), 'more in', sum(1 for x in deltas if x > 0),
          'fewer in', sum(1 for x in deltas if x < 0), '| no bit again less no bit: median', statistics.median(spread))
