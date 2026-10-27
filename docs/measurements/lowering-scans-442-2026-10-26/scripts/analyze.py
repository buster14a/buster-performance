#!/usr/bin/env python3
# #442: per-stage sums of per-file medians, per round and tree; paired deltas against the first tree named.
import sys, re, glob, statistics, collections
d = sys.argv[1]; trees = sys.argv[2].split(','); base = trees[0]
stages = sys.argv[3].split(',') if len(sys.argv) > 3 else ['ns', 'select', 'emit', 'publish', 'object']
data = collections.defaultdict(dict)  # (round, tree) -> file -> dict
for p in glob.glob(f'{d}/round-*-*.txt'):
    m = re.search(r'round-(\d+)-(\w+)\.txt$', p); r, t = int(m.group(1)), m.group(2)
    if t not in trees: continue
    for line in open(p):
        if 'file=' in line and 'ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:])
            data[(r, t)][f['file'].rsplit('/', 1)[-1]] = f
rounds = sorted({r for r, t in data})
common = set.intersection(*[set(v) for v in data.values()])
same = {f for f in common if len({(data[k][f]['functions'], data[k][f]['objects'], data[k][f]['object_bytes']) for k in data}) == 1}
def total(r, t, s, files): return sum(float(data[(r, t)][f][s]) for f in files)
for label, files in (('all', common), ('same-output', same), ('differing', common - same)):
    print(f'== {label}: {len(files)} files')
    for s in stages:
        row = []
        for t in trees:
            vals = [total(r, t, s, files) for r in rounds]
            row.append(f'{t}={statistics.median(vals):,.0f} [{min(vals):,.0f}..{max(vals):,.0f}]')
        print(f'  {s:8s} ' + '  '.join(row))
        for t in trees[1:]:
            if any(total(r, base, s, files) == 0 for r in rounds):
                print(f'           {t} vs {base}: n/a (a round of {base} sums to 0)'); continue
            ds = [100 * (total(r, t, s, files) / total(r, base, s, files) - 1) for r in rounds]
            print(f'           {t} vs {base}: paired rounds {", ".join(f"{x:+.2f}%" for x in ds)}  median {statistics.median(ds):+.2f}%')
diff = sorted(common - same)
for f in diff:
    print('differs:', f, {t: (data[(rounds[0], t)][f]['functions'], data[(rounds[0], t)][f]['objects'], data[(rounds[0], t)][f]['object_bytes']) for t in trees})
