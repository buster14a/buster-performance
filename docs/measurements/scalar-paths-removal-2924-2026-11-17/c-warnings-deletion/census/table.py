# table.py DIR: each helper's arm counts (arm 0 the scalar twin's, 1 and up the vector path's), summed over a census
# file's lines (one per process), by mode and list: DIR/{default,scalar}-{sqlite,lua,musl}.census.
import os, sys, collections
D = sys.argv[1]
runs = [f'{m}-{l}' for m in ('default', 'scalar') for l in ('sqlite', 'lua', 'musl')]
counts = {r: collections.defaultdict(lambda: [0, 0, 0, 0]) for r in runs}
order = []
for r in runs:
    for line in open(os.path.join(D, r + '.census')):
        w = line.split()
        if w[0] != 'wcensus':
            continue
        if w[1] not in order:
            order.append(w[1])
        for i, n in enumerate(w[2:6]):
            counts[r][w[1]][i] += int(n)
print('helper: arm0(scalar)/arm1/arm2'.ljust(42) + ' | ' + ' | '.join(runs))
for h in order:
    print(h.ljust(42) + ' | ' + ' | '.join('/'.join(str(n) for n in counts[r][h][:3]) if h in counts[r] else '-' for r in runs))
