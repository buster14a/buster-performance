#!/usr/bin/env python3
# compile_table.py COMPILE.tsv BASE VARIANT: compile.sh's runs as a table: per input and mode, each build's medians (ms,
# user cycles, instructions) and the mean of 100 ln(VARIANT / BASE) of user cycles over the rounds' pairs, with its 95%
# interval (Student's t); round 0, the warm-up, left out.
import sys, statistics, collections, math
path, base, variant = sys.argv[1:4]
T = {9: 2.262, 10: 2.228, 11: 2.201, 12: 2.179}
rows = collections.defaultdict(list); pairs = collections.defaultdict(dict)
for line in open(path):
    r, i, m, n, ms, cycles, instructions, status = line.rstrip('\n').split('\t')
    if r == '0': continue
    if status != '0': print(f'# failed: {line.strip()}'); continue
    rows[(i, m, n)].append((float(ms), int(cycles), int(instructions))); pairs[(i, m, r)][n] = int(cycles)
print('input\tmode\tbuild\tms\tcycles M\tinstructions M\tcycles, 100 ln(variant/base)\t95%')
for i, m in sorted(set((i, m) for i, m, n in rows)):
    ratios = [100 * math.log(p[variant] / p[base]) for (ii, mm, r), p in pairs.items() if ii == i and mm == m and base in p and variant in p]
    mean = statistics.mean(ratios); half = T.get(len(ratios) - 1, 2.0) * statistics.stdev(ratios) / math.sqrt(len(ratios))
    for n in (base, variant):
        v = rows[(i, m, n)]
        tail = f'\t{mean:+.2f}\t{mean - half:+.2f} to {mean + half:+.2f}' if n == variant else '\t\t'
        print(f'{i}\t{m}\t{n}\t{statistics.median(x[0] for x in v):.1f}\t{statistics.median(x[1] for x in v) / 1e6:.1f}\t{statistics.median(x[2] for x in v) / 1e6:.1f}{tail}')
