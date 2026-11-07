#!/usr/bin/env python3
# #442 (2026-11-06): each file's floor, its least per-run minimum over every round, summed per tree and stage, against
# the first tree named, for all files, for the files whose output #418 kept or changed (the counts and object sizes of
# --pair's two trees, main before #418 and #418's merge, the same or not), and by token count. Also checks that the
# trees of --identical (current main and the changes) lowered every file to the same counts and object sizes.
# Usage: floor442.py ROUNDS_DIR --pair A,B --identical C,D,... TREE...
import sys, re, glob, collections
args = sys.argv[1:]
d = args.pop(0)
pair = identical = None
while args and args[0].startswith('--'):
    flag = args.pop(0); value = args.pop(0)
    if flag == '--pair': pair = value.split(',')
    elif flag == '--identical': identical = value.split(',')
trees = args
keys = ['min_ns', 'min_select', 'min_emit', 'min_publish', 'min_object']
floor = collections.defaultdict(dict); tokens = {}; output = collections.defaultdict(dict)
for p in glob.glob(f'{d}/round-*-*.txt'):
    t = re.search(r'round-\d+-(\w+)\.txt$', p).group(1)
    for line in open(p):
        if 'file=' in line and ' ns=' in line:
            f = dict(kv.split('=', 1) for kv in line.split()[1:]); n = f['file'].rsplit('/', 1)[-1]; tokens[n] = int(f['tokens'])
            output[t][n] = (f['functions'], f['objects'], f['object_bytes'])
            old = floor[t].get(n)
            floor[t][n] = [min(float(f[k]), old[i]) if old else float(f[k]) for i, k in enumerate(keys)]
base = trees[0]
names = [n for n in floor[base] if all(n in floor[t] for t in trees)]
if identical:
    differ = [n for n in names if len({output[t][n] for t in identical}) != 1]
    print(f'identical trees {",".join(identical)}: {len(names) - len(differ)} of {len(names)} files the same counts and object sizes; differing: {differ}')
kept = lambda n: output[pair[0]][n] == output[pair[1]][n] if pair else True
groups = {'all': lambda n: True}
if pair:
    groups[f'output kept by {pair[1]}'] = kept
    groups[f'output changed by {pair[1]}'] = lambda n: not kept(n)
groups.update({'tokens<300': lambda n: tokens[n] < 300, '300<=tokens<3000': lambda n: 300 <= tokens[n] < 3000, 'tokens>=3000': lambda n: tokens[n] >= 3000})
for g, keep in groups.items():
    files = sorted(n for n in names if keep(n))
    print(f'== {g}: {len(files)} files' + (f' {files}' if len(files) < 10 else ''))
    for i, k in enumerate(keys):
        b = sum(floor[base][n][i] for n in files)
        print(f'  {k:12s} ' + '  '.join(f'{t}={sum(floor[t][n][i] for n in files):,.0f} ({(f"{100*(sum(floor[t][n][i] for n in files)/b-1):+.1f}%" if b else "n/a")})' for t in trees))
