#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_medians.py DIRECTORY NAME...: the median of each --time-stages stage over DIRECTORY/NAME-*.txt, a column per
# NAME, in ms, with each run's token count; stages under 0.05 ms in every column are left out.
import glob, statistics, sys, collections

directory, names = sys.argv[1], sys.argv[2:]
table = collections.OrderedDict()
tokens = {}
counts = {}
for name in names:
    runs = collections.defaultdict(list)
    files = sorted(glob.glob(f'{directory}/{name}-*.txt'))
    counts[name] = len(files)
    for path in files:
        for line in open(path, errors='replace'):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'time-stage' and p[1] != 'stage':
                runs[p[1]].append(float(p[2]))
            if p[0] == 'time-process' and p[1] == 'tokens':
                tokens[name] = int(p[2])
    for stage, values in runs.items():
        table.setdefault(stage, {})[name] = statistics.median(values)
print('stage\t' + '\t'.join(f'{n} ({counts[n]} runs, {tokens.get(n, 0)} tokens)' for n in names))
for stage, row in table.items():
    if max(row.values()) >= 0.05:
        print(stage + '\t' + '\t'.join(f'{row.get(n, 0.0):.3f}' for n in names))
