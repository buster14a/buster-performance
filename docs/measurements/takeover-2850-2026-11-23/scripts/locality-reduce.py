#!/usr/bin/env python3
# locality-reduce.py DIRECTORY: from runs.tsv (variant round user-cycles kernel-cycles instructions L1-misses faults
# object stderr-lines) and chunks.txt, each variant's medians, and for each K the bodies' cost as the sum over its
# chunks of (chunk - none) beside (whole - none).
import sys, os, statistics, collections
d = sys.argv[1]
runs = collections.defaultdict(list)
for line in open(os.path.join(d, 'runs.tsv')):
    p = line.split()
    runs[p[0]].append([int(x) for x in p[2:7]])
med = {v: [statistics.median(r[i] for r in rs) for i in range(5)] for v, rs in runs.items()}
names = ['user cycles', 'kernel cycles', 'instructions', 'L1 misses', 'faults']
tokens = {}
for line in open(os.path.join(d, 'chunks.txt')):
    p = line.split()
    if p[0] == 'tokens':
        total_tokens = int(p[1]); body_tokens = int(p[5])
    else:
        tokens[p[0]] = int(p[4])
print(f'tokens {total_tokens}, in bodies {body_tokens}; runs a variant: {min(len(r) for r in runs.values())} to {max(len(r) for r in runs.values())}')
whole, none = med['whole'], med['none']
print(f"{'':28s}" + ''.join(f'{n:>16s}' for n in names))
print(f"{'whole, M':28s}" + ''.join(f'{x / 1e6:16.3f}' for x in whole))
print(f"{'no bodies, M':28s}" + ''.join(f'{x / 1e6:16.3f}' for x in none))
print(f"{'the bodies (whole - none), M':28s}" + ''.join(f'{(a - b) / 1e6:16.3f}' for a, b in zip(whole, none)))
ks = sorted({int(v[1:].split('-')[0]) for v in med if v.startswith('k')})
for k in ks:
    sums = [sum(med[f'k{k}-c{c}'][i] - none[i] for c in range(k)) for i in range(5)]
    print(f"{f'in {k} batches, summed, M':28s}" + ''.join(f'{x / 1e6:16.3f}' for x in sums))
    print(f"{'  of the whole unit s':28s}" + ''.join(f'{100 * s / (a - b):15.1f}%' for s, a, b in zip(sums, whole, none)))
    per = sorted((med[f"k{k}-c{c}"][0] + med[f"k{k}-c{c}"][1] - none[0] - none[1]) / max(tokens[f"k{k}-c{c}"], 1) for c in range(k))
    print(f"  cycles a body token by batch: least {per[0]:.0f}, median {statistics.median(per):.0f}, most {per[-1]:.0f} (the whole unit: {(whole[0] + whole[1] - none[0] - none[1]) / body_tokens:.0f})")
