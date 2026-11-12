#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# gains.py REFERENCE DIRECTORY...: each configuration of prototype7.sh's or prototype8.sh's runs against REFERENCE (a
# configuration's name, src): one Markdown table for all the directories (a corpus each), a row a configuration, with
# its median wall time, the difference from the reference's in ms, its user cycles and their difference in percent,
# its peak (peaks.tsv) and the count of objects that differ from the reference's (objects.txt).
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

reference = sys.argv[1]
print('| corpus | order | runs | wall ms | against ' + reference + ' | user cycles, M | against ' + reference + ' | user instructions, M | peak MB | objects that differ |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for d in sys.argv[2:]:
    corpus = os.path.basename(d.rstrip('/'))
    by = runs(os.path.join(d, 'runs.tsv'))
    peaks = runs(os.path.join(d, 'peaks.tsv'))
    differ = {}
    for line in open(os.path.join(d, 'objects.txt')):
        p = line.split()
        differ[p[0]] = f'{p[-1]} of {p[3]}'
    base_wall, base_cycles = median(by[reference], 'wall_ms'), median(by[reference], 'user_cycles')
    canonical = ['src', 'two', 'shared', 'quiet', 'prefix', 'inline', 'one', 'exact']
    for config in sorted(by, key=lambda c: canonical.index(c) if c in canonical else len(canonical)):
        rows = by[config]
        wall, cycles = median(rows, 'wall_ms'), median(rows, 'user_cycles')
        delta_wall = '' if config == reference else f'{wall - base_wall:+.1f} ms'
        delta_cycles = '' if config == reference else f'{100 * (cycles / base_cycles - 1):+.2f}%'
        print(f"| {corpus} | {config} | {len(rows)} | {wall:.1f} | {delta_wall} | {cycles / 1e6:,.1f} | {delta_cycles} | {median(rows, 'user_instructions') / 1e6:,.1f} | "
              f"{median(peaks[config], 'peak_kib') / 1024:.1f} | {differ.get(config, '')} |")
