# table.py SITES LOGS: each selector's counts (scalar arm taken / not taken) by mode and list, summed over processes and
# translation units. SITES: areas.py's rows (file:line, bit, kind, text); the census line numbers are main's.
import sys, collections, os
sites = [l.rstrip('\n').split('\t') for l in open(sys.argv[1])]
logs = sys.argv[2]
runs = [f'{m}-{l}' for m in ('default', 'wall', 'scalar') for l in ('sqlite', 'lua', 'musl', 'buster')]
counts = {r: collections.defaultdict(lambda: [0, 0]) for r in runs}
for r in runs:
    for line in open(os.path.join(logs, r + '.census')):
        w = line.split()
        if w[0] != 'path':
            continue
        key = w[1].split('src/buster/compiler/')[-1]
        counts[r][key][0] += int(w[2])
        counts[r][key][1] += int(w[3])
def cell(r, key):
    c = counts[r].get(key)
    return '-' if c is None else f'{c[1]}/{c[0]}'
print('site (scalar arm / other)'.ljust(44) + ' | ' + ' | '.join(runs))
for s in sites:
    key = s[0]
    print(f'{key:44s} | ' + ' | '.join(cell(r, key) for r in runs) + '   ' + s[3][:70])
