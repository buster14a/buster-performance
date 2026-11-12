#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# runs_table.py [--title TEXT] DIRECTORY...: runs.py's results as a Markdown table, a row a configuration in the order
# of its first run: the runs' count, the median wall time with its range, user cycles with their difference from the
# first configuration's, user instructions, kernel cycles, and (where the directory has peaks.tsv, a pass without perf)
# the peak resident set. The warm-up rows and runs.py's own summary rows are left out. Where the wall times are all zero
# (overhead.sh and baseline2.sh read perf stat -x, whose duration_time this perf prints as 0), the column has the task
# clock instead, marked with an asterisk.
import sys, os, statistics, collections

def runs(path):
    by = collections.OrderedDict()
    header = None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p
            continue
        if p[0] != 'run':
            continue
        row = dict(zip(header, p))
        by.setdefault(row['config'], []).append(row)
    return by

def median(rows, key):
    return statistics.median(float(r[key]) for r in rows)

args = sys.argv[1:]
title = None
if args and args[0] == '--title':
    title = args[1]
    args = args[2:]
for d in args:
    by = runs(os.path.join(d, 'runs.tsv'))
    peaks = runs(os.path.join(d, 'peaks.tsv')) if os.path.exists(os.path.join(d, 'peaks.tsv')) else {}
    print(f"### {title or os.path.relpath(d)}")
    print()
    print('| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |')
    print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
    base = None
    starred = False
    for config, rows in by.items():
        wall = [float(r['wall_ms']) for r in rows]
        mark = ''
        if max(wall) == 0.0:
            wall = [float(r['task_ms']) for r in rows]
            mark = '*'
            starred = True
        cycles = median(rows, 'user_cycles')
        base = cycles if base is None else base
        peak = f"{median(peaks[config], 'peak_kib') / 1024:.1f}" if config in peaks else ''
        print(f"| {config} | {len(rows)} | {statistics.median(wall):.1f}{mark} ({min(wall):.1f} to {max(wall):.1f}) | {cycles / 1e6:,.1f} | {(cycles / base - 1) * 100:+.2f}% | "
              f"{median(rows, 'user_instructions') / 1e6:,.1f} | {median(rows, 'kernel_cycles') / 1e6:,.1f} | {peak} |")
    if starred:
        print()
        print("\\* The task clock: these runs' wall times weren't read.")
    print()
