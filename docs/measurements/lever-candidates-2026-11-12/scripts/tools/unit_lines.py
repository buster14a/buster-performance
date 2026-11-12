#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# unit_lines.py TREE: what each unity unit of the stage 1 build reads, by clang's own dependency list (-MM with the
# build's definitions): the lines of every file the unit reaches, test files apart. Whole files are counted, so what a
# unit compiles after its own conditionals is at most this. Not a timing: it runs anywhere.
import collections
import os
import re
import subprocess
import sys

tree = sys.argv[1]
directory = os.path.join(tree, 'src/buster/compiler')
units = sorted(f[len('main_unit_'):-2] for f in os.listdir(directory) if f.startswith('main_unit_') and f.endswith('.c'))
rows = []
for unit in units:
    command = ['clang', '-MM', '-march=native', '-I' + os.path.join(tree, 'src'), '-fwrapv', '-funsigned-char', '-DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_STRONG',
               '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"', '-DBUSTER_EXECUTABLE_UNIT', '-DBUSTER_HOST_STATIC=1', os.path.join(directory, f'main_unit_{unit}.c')]
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        print(unit, 'failed:', result.stderr[:300])
        continue
    files = [f for f in result.stdout.replace('\\\n', ' ').split()[1:] if f.startswith(tree)]
    lines = collections.Counter()
    for f in files:
        base = os.path.basename(f)
        kind = 'test' if re.search(r'_test(_|\.)|_tests?\.|test_|fuzz', base) else 'benchmark' if 'benchmark' in base else 'header' if base.endswith('.h') else 'other'
        lines[kind] += sum(1 for _ in open(f, errors='replace'))
    rows.append((sum(lines.values()), unit, lines, len(files)))
rows.sort(reverse=True)
print('unit\tfiles\tlines\ttest files\' lines\tbenchmark files\'\theaders\'\tother\ttests\' share')
for total, unit, lines, count in rows:
    print(f"{unit}\t{count}\t{total}\t{lines['test']}\t{lines['benchmark']}\t{lines['header']}\t{lines['other']}\t{100 * lines['test'] / total:.1f}%")
print(f"all units\t\t{sum(r[0] for r in rows)}\t{sum(r[2]['test'] for r in rows)}\t{sum(r[2]['benchmark'] for r in rows)}\t{sum(r[2]['header'] for r in rows)}\t{sum(r[2]['other'] for r in rows)}")
# The repository's C sources once each.
total = collections.Counter()
for name in os.listdir(directory):
    if name.endswith(('.c', '.h', '.inc')):
        kind = 'test' if re.search(r'_test(_|\.)|_tests?\.|test_|fuzz', name) else 'benchmark' if 'benchmark' in name else 'other'
        total[kind] += sum(1 for _ in open(os.path.join(directory, name), errors='replace'))
print(f"src/buster/compiler once\t\t{sum(total.values())}\t{total['test']}\t{total['benchmark']}\t\t{total['other']}\t{100 * total['test'] / sum(total.values()):.1f}%")
