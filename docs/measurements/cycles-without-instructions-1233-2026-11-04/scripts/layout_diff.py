#!/usr/bin/env python3
"""#1233: where each function of main's executable sits in the merge's: nm -n -S of both, functions keyed by name and
occurrence (static copies share names), runs of functions with the same displacement, with their address ranges."""
import sys, collections
def load(path):
    seen = collections.Counter(); out = {}; order = []
    for line in open(path):
        f = line.split()
        if len(f) != 4 or f[2] not in 'tTwW':
            continue
        addr, size, name = int(f[0], 16), int(f[1], 16), f[3]
        seen[name] += 1
        key = (name, seen[name])
        out[key] = (addr, size); order.append(key)
    return out, order
m, morder = load(sys.argv[1]); h, horder = load(sys.argv[2])
runs = []
for key in morder:
    if key not in h:
        runs.append(('gone', key, m[key])); continue
    d = h[key][0] - m[key][0]
    ds = h[key][1] - m[key][1]
    if runs and runs[-1][0] == 'run' and runs[-1][1] == d:
        r = runs[-1]; r[3] = m[key][0] + m[key][1]; r[4] += 1; r[5] += abs(ds) > 0
    else:
        runs.append(['run', d, m[key][0], m[key][0] + m[key][1], 1, int(abs(ds) > 0), key[0]])
for r in runs:
    if r[0] == 'gone':
        print(f'  gone {r[1][0]} at {r[2][0]:#x} size {r[2][1]}')
    else:
        print(f'{r[2]:#10x}-{r[3]:#10x} {r[4]:6d} functions moved {r[1]:+8d} ({r[1] % 64:2d} mod 64, {r[1] % 4096:4d} mod 4096), {r[5]} resized; first {r[6]}')
new = [k for k in horder if k not in m]
print('new in merge:', len(new), ' '.join(f'{k[0]}@{h[k][0]:#x}/{h[k][1]}' for k in new[:60]))
