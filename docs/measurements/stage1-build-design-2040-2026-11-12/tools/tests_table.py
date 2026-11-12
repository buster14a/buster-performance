#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tests_table.py DIRECTORY: the tests' run time by executable, from tests.sh's NAME.tsv files in DIRECTORY: one row a
# command of scripts/tests.list, one column an executable (release first), each cell the command's wall time in
# seconds (with its status when it isn't 0), and the totals over the commands every listed executable ran.
import collections
import os
import sys

directory = sys.argv[1]
rows = collections.OrderedDict()
names = []
for name in sorted(os.listdir(directory)):
    if name.endswith('.tsv'):
        names.append(name[:-4])
        for line in open(os.path.join(directory, name)):
            _index, command, times, status = line.rstrip('\n').split('\t')
            rows.setdefault(command, {})[name[:-4]] = (float(times.split()[0]), status)
names.sort(key=lambda n: (n != 'release', n))
print('command\t' + '\t'.join(names))
for command, cells in rows.items():
    print(command + '\t' + '\t'.join(f"{cells[n][0]:.2f}{'' if cells[n][1] == 'rc=0' else ' ' + cells[n][1]}" if n in cells else '' for n in names))
for n in names:
    shared = [c for c in rows if 'release' in rows[c] and n in rows[c]]
    own = sum(rows[c][n][0] for c in shared)
    reference = sum(rows[c]['release'][0] for c in shared)
    print(f'{n}: {len(shared)} commands, {own:.1f} s; release on the same commands {reference:.1f} s; {own / reference:.2f} times' if reference else f'{n}: no command in common with release')
