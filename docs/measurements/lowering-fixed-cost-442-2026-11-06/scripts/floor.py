#!/usr/bin/env python3
# #442: each file's floor, its least per-run minimum over every round, summed per tree and stage, by token count. On a
# host whose speed shifts for stretches of a run (this record's), the floor compares the trees in their fast state.
# The same-output subset is the files every tree named lowers to the same counts and object size.
# Usage: floor.py ROUNDS_DIR TREE...
import sys, re, glob, collections
d, trees = sys.argv[1], sys.argv[2:]
keys = ['min_ns', 'min_select', 'min_emit', 'min_publish', 'min_object']
floor = collections.defaultdict(dict); tokens = {}; outputs = collections.defaultdict(set)
for p in glob.glob(f'{d}/round-*-*.txt'):
    t = re.search(r'round-\d+-(\w+)\.txt$', p).group(1)
    for line in open(p):
        if 'file=' in line and ' ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:]); n = f['file'].rsplit('/', 1)[-1]; tokens[n] = int(f['tokens'])
            if t in trees:
                outputs[n].add((f['functions'], f['objects'], f['object_bytes']))
            old = floor[t].get(n)
            floor[t][n] = [min(float(f[k]), old[i]) if old else float(f[k]) for i, k in enumerate(keys)]
groups = {'all': lambda n: True, 'same output': lambda n: len(outputs[n]) == 1, 'output differs': lambda n: len(outputs[n]) > 1, 'tokens<300': lambda n: tokens[n] < 300, '300<=tokens<3000': lambda n: 300 <= tokens[n] < 3000, 'tokens>=3000': lambda n: tokens[n] >= 3000}
base = trees[0]
for g, keep in groups.items():
    files = [n for n in floor[base] if keep(n) and all(n in floor[t] for t in trees)]
    print(f'== {g}: {len(files)} files')
    for i, k in enumerate(keys):
        b = sum(floor[base][n][i] for n in files)
        print(f'  {k:12s} ' + '  '.join(f'{t}={sum(floor[t][n][i] for n in files):,.0f} ({(f'{100*(sum(floor[t][n][i] for n in files)/b-1):+.1f}%' if b else 'n/a')})' for t in trees))
