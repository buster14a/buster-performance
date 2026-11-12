#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# baseline_table.py DIRECTORY...: baseline3.sh's results as one table, a row a corpus, lanes and configuration: the
# median wall time with its range, user and kernel cycles, user instructions (runs.tsv, under perf), the peak resident
# set (peaks.tsv, without perf: wait4's of a direct child), and Tier 1's coverage (tier1-report.txt).
import sys, os

def rows(path):
    out = {}
    header = None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p; continue
        if p[0] in ('median', 'low', 'high'):
            out[(p[0], p[3])] = dict(zip(header[5:], (float(x) for x in p[5:])))
    return out

print('| corpus | lanes | compile | wall ms (range) | user cycles, M | kernel cycles, M | user instructions, M | peak MB | functions by Tier 1 |')
print('| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |')
for d in sys.argv[1:]:
    name, lanes = os.path.basename(d.rstrip('/')).rsplit('-', 1)
    r = rows(os.path.join(d, 'runs.tsv'))
    p = rows(os.path.join(d, 'peaks.tsv'))
    report = dict(x.split('=') for x in open(os.path.join(d, 'tier1-report.txt')).read().split('\t') if '=' in x)
    for config in ('default', 'tier1'):
        m, lo, hi = r[('median', config)], r[('low', config)], r[('high', config)]
        coverage = f"{report['compiled']} of {report['functions']}" if config == 'tier1' else ''
        print(f"| {name} | {lanes} | {'`--tier1`' if config == 'tier1' else 'default'} | {m['wall_ms']:.1f} ({lo['wall_ms']:.1f} to {hi['wall_ms']:.1f}) | {m['user_cycles'] / 1e6:,.1f} | "
              f"{m['kernel_cycles'] / 1e6:,.1f} | {m['user_instructions'] / 1e6:,.1f} | {p[('median', config)]['peak_kib'] / 1024:.1f} | {coverage} |")
