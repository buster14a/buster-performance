#!/usr/bin/env python3
# proto_table.py RUNS.tsv [BASE]: proto-runs.sh's runs as a table: for speedtest1 and for Lua (the sum of its five
# scripts), each variant against BASE (base) paired by round and placement: the mean of 100 ln(variant / BASE) of user
# cycles with two 95% intervals (Student's t): over the placements' means, which takes the layout as what varies (the
# one to quote: a placement's rounds are not independent draws of a layout), and over all the pairs; the same mean of
# instructions; the placements at which the variant's median is the faster; and each variant's medians over all
# placements and rounds.
import sys, math, collections, statistics
path = sys.argv[1]; base = sys.argv[2] if len(sys.argv) > 2 else 'base'
T = {1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571, 6: 2.447, 7: 2.365, 8: 2.306, 9: 2.262, 10: 2.228, 11: 2.201, 12: 2.179, 13: 2.160, 14: 2.145, 15: 2.131, 16: 2.120,
     17: 2.110, 18: 2.101, 19: 2.093, 20: 2.086, 24: 2.064, 29: 2.045, 30: 2.042, 39: 2.023, 40: 2.021, 60: 2.000, 120: 1.980}
def t95(df):
    keys = sorted(T)
    best = keys[0]
    for k in keys:
        if k <= df: best = k
    return T[best]
runs = collections.defaultdict(lambda: [0.0, 0, 0, 0])  # (program group, round, placement, name) -> ms, cycles, instructions, parts
names = []
failed = 0
for line in open(path):
    f = line.rstrip('\n').split('\t')
    if f[0] != 'measured': continue
    if f[10] != '0': failed += 1; continue
    group = 'speedtest1' if f[2] == 'speedtest1' else 'lua'
    key = (group, f[1], f[3], f[4])
    r = runs[key]; r[0] += float(f[5]); r[1] += int(f[6]); r[2] += int(f[7]); r[3] += 1
    if f[4] not in names: names.append(f[4])
print(f'# failed runs: {failed}')
for group, parts in (('speedtest1', 1), ('lua', 5)):
    keys = sorted({(k[1], k[2]) for k in runs if k[0] == group and runs[k][3] == parts})
    placements = sorted({k[1] for k in keys}, key=int)
    if not keys: continue
    print(f'\n{group}: {len(placements)} placements, {len(keys)} pairs a variant')
    print('variant\tms\tcycles M\tinstr M\tcycles, 100 ln(v/base)\t95% over placements\t95% over pairs\tinstr, 100 ln\tfaster at')
    for name in names:
        ms = [runs[(group, r, p, name)][0] for r, p in keys if runs[(group, r, p, name)][3] == parts]
        cy = [runs[(group, r, p, name)][1] for r, p in keys if runs[(group, r, p, name)][3] == parts]
        ins = [runs[(group, r, p, name)][2] for r, p in keys if runs[(group, r, p, name)][3] == parts]
        row = f'{name}\t{statistics.median(ms):.1f}\t{statistics.median(cy) / 1e6:.1f}\t{statistics.median(ins) / 1e6:.1f}'
        if name != base:
            d = []; di = []
            for r, p in keys:
                a = runs[(group, r, p, name)]; b = runs[(group, r, p, base)]
                if a[3] == parts and b[3] == parts:
                    d.append(100 * math.log(a[1] / b[1])); di.append(100 * math.log(a[2] / b[2]))
            mean = statistics.mean(d); half = t95(len(d) - 1) * statistics.stdev(d) / math.sqrt(len(d))
            faster = 0; means = []
            for p in placements:
                va = [runs[(group, r, q, name)][1] for r, q in keys if q == p]; vb = [runs[(group, r, q, base)][1] for r, q in keys if q == p]
                faster += statistics.median(va) < statistics.median(vb)
                means.append(statistics.mean(100 * math.log(runs[(group, r, q, name)][1] / runs[(group, r, q, base)][1]) for r, q in keys if q == p))
            wide = t95(len(means) - 1) * statistics.stdev(means) / math.sqrt(len(means))
            center = statistics.mean(means)
            row += f'\t{center:+.2f}\t{center - wide:+.2f} to {center + wide:+.2f}\t{mean - half:+.2f} to {mean + half:+.2f}\t{statistics.mean(di):+.2f}\t{faster} of {len(placements)}'
        print(row)
