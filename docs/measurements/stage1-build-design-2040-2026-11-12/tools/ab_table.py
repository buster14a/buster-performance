#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# ab_table.py REPORT.txt...: time-runs' comparisons (ab.sh's reports), one row a build: the workload's wall time and
# user cycles, each build's median over its placements and copies, its difference from the first build and that
# difference's range over the placements, as time-runs prints them; and the paired differences by placement, each
# build's placement median against the first build's same placement, with their mean. Tab-separated.
import os
import re
import statistics
import sys

print('comparison\tmeasure\tbuild\truns\tmedian\tagainst the first build\trange over placements\tpaired by placement (%)\tmean of the pairs (%)')
for path in sys.argv[1:]:
    name = os.path.basename(path)[:-4]
    # The instructions each build's runs executed, which time-runs lists run by run and doesn't compare.
    instructions = {}
    for line in open(path, errors='replace'):
        run = re.match(r'run \d+ list \d+ ([\w-]+)[ :].* (\d+) user cycles, (\d+) instructions', line)
        if run:
            instructions.setdefault(run.group(1), []).append(int(run.group(3)))
    base = None
    for build, values in instructions.items():
        median = statistics.median(values)
        base = median if base is None else base
        print(f"{name}\tuser instructions (millions)\t{build}\t{len(values)}\t{median / 1e6:.3f}\t{100 * (median / base - 1):+.2f}%")
    measure = None
    first = None
    for line in open(path, errors='replace'):
        header = re.match(r'list \d+, (.*):$', line.strip())
        if header:
            measure = header.group(1)
            first = None
            continue
        row = re.match(r'\s+([\w-]+): (\d+) runs, median ([\d.]+); placements ([\d., ]+) \(spread', line)
        if measure and row:
            build, runs, median = row.group(1), row.group(2), float(row.group(3))
            placements = [float(v) for v in row.group(4).split(', ')]
            against = re.search(r'against [\w-]+ ([+-][\d.]+%) \(over placements ([+-][\d.]+% to [+-][\d.]+%)', line)
            if first is None:
                first = placements
            pairs = [100 * (b / a - 1) for a, b in zip(first, placements)] if len(first) == len(placements) else []
            print(f"{name}\t{measure}\t{build}\t{runs}\t{median:.3f}\t{against.group(1) if against else ''}\t{against.group(2) if against else ''}\t"
                  f"{' '.join(f'{p:+.2f}' for p in pairs)}\t{statistics.mean(pairs):+.2f}" if pairs else f"{name}\t{measure}\t{build}\t{runs}\t{median:.3f}")
