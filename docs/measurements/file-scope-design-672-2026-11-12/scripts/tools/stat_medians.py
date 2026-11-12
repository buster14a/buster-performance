#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stat_medians.py DIR [PREFIX]: perf stat's CSVs DIR/PREFIX-NAME-ROUND.csv (default prefix `stat`) as one row a NAME:
# each event's median over the rounds, with the rounds' count and the range of the task clock.
import os, re, sys, statistics, collections

directory = sys.argv[1]
prefix = sys.argv[2] if len(sys.argv) > 2 else 'stat'
runs = collections.defaultdict(lambda: collections.defaultdict(list))
events = []
for name in sorted(os.listdir(directory)):
    m = re.fullmatch(re.escape(prefix) + r'-(.+)-(\d+)\.csv', name)
    if not m:
        continue
    for line in open(os.path.join(directory, name)):
        p = line.strip().split(',')
        if len(p) < 3 or line.startswith('#') or not p[0]:
            continue
        try:
            value = float(p[0])
        except ValueError:
            continue
        event = p[2]
        if event not in events:
            events.append(event)
        runs[m.group(1)][event].append(value)
print('variant\truns\t' + '\t'.join(events) + '\ttask-clock range')
for variant, values in runs.items():
    row = [variant, str(max(len(v) for v in values.values()))]
    for e in events:
        v = values.get(e, [])
        row.append(f'{statistics.median(v):.6g}' if v else '')
    clock = values.get('task-clock', [])
    row.append(f'{min(clock):.2f} to {max(clock):.2f}' if clock else '')
    print('\t'.join(row))
