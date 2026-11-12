#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# pgo_table.py DIRECTORY...: pgo.sh's runs as one Markdown table, a row a corpus and compile (--tier1, default): the
# plain executable's and the profile-guided one's median wall times and user cycles, and the change of each.
import sys, os, statistics, collections

def runs(path):
    by, header = collections.OrderedDict(), None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p
            continue
        if p[0] == 'run':
            by.setdefault(p[3], []).append(dict(zip(header, p)))
    return by

def median(rows, key):
    return statistics.median(float(r[key]) for r in rows)

print('| corpus | compile | runs | plain, wall ms | profile-guided | change | plain, user cycles, M | profile-guided | change | objects |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |')
for d in sys.argv[1:]:
    by = runs(os.path.join(d, 'runs.tsv'))
    agree = open(os.path.join(d, 'objects.txt')).read().strip()
    for mode, label in (('tier1', '`--tier1`'), ('default', 'default')):
        plain, guided = by[f'plain-{mode}'], by[f'pgo-{mode}']
        w0, w1 = median(plain, 'wall_ms'), median(guided, 'wall_ms')
        c0, c1 = median(plain, 'user_cycles'), median(guided, 'user_cycles')
        print(f"| {os.path.basename(d.rstrip('/'))} | {label} | {len(plain)} | {w0:.1f} | {w1:.1f} | {100 * (w1 / w0 - 1):+.1f}% | {c0 / 1e6:,.1f} | {c1 / 1e6:,.1f} | {100 * (c1 / c0 - 1):+.1f}% | {agree} |")
