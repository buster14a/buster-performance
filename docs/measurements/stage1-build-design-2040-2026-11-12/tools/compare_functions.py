#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# compare_functions.py A.tsv B.tsv FUNCTIONS.tsv [LIST.txt]: two builds of one unit, function by function, from
# object_functions' lines (name, section, size, hash of the code and its relocations): how many functions have the same
# machine code in both, how many differ and how many only one build emits, with their code sizes, for the product's
# functions and the tests' apart (FUNCTIONS.tsv is function_files' map; the rule for a test file is unit_lines.py's).
# The split's .buster_split aliases are left out. With LIST.txt, writes the names that differ or are in one build only.
import os
import re
import sys


def load(path):
    rows = {}
    for line in open(path):
        name, section, size, digest = line.rstrip('\n').split('\t')
        if not name.endswith('.buster_split'):
            rows[name] = (int(size), digest, section)
    return rows


def kind_of(base):
    if re.search(r'_test(_|\.)|_tests?\.|test_|fuzz', base):
        return 'test'
    if 'benchmark' in base or '_measure' in base:
        return 'benchmark'
    return 'product'


a, b = load(sys.argv[1]), load(sys.argv[2])
files = {}
for line in open(sys.argv[3]):
    fields = line.rstrip('\n').split('\t')
    files[fields[0]] = os.path.basename(fields[1])
names = sorted(set(a) | set(b))
changed = []
print(f'{sys.argv[1]}: {len(a)} functions, {sum(v[0] for v in a.values())} bytes of code')
print(f'{sys.argv[2]}: {len(b)} functions, {sum(v[0] for v in b.values())} bytes of code')
for kind in ('product', 'test', 'benchmark', 'unknown'):
    same = different = only_a = only_b = 0
    bytes_same = bytes_different_a = bytes_different_b = bytes_only_a = bytes_only_b = 0
    for name in names:
        # A function the optimizer cloned or outlined keeps its origin's name before the first dot.
        origin = name.split('.')[0]
        this = kind_of(files[origin]) if origin in files else 'unknown'
        if this != kind:
            continue
        if name in a and name in b:
            if a[name][:2] == b[name][:2]:
                same += 1
                bytes_same += a[name][0]
            else:
                different += 1
                bytes_different_a += a[name][0]
                bytes_different_b += b[name][0]
                changed.append(f'{kind}\tdiffers\t{name}\t{a[name][0]}\t{b[name][0]}')
        elif name in a:
            only_a += 1
            bytes_only_a += a[name][0]
            changed.append(f'{kind}\tonly in A\t{name}\t{a[name][0]}\t')
        else:
            only_b += 1
            bytes_only_b += b[name][0]
            changed.append(f'{kind}\tonly in B\t{name}\t\t{b[name][0]}')
    total = same + different + only_a + only_b
    if total:
        print(f'{kind:9s} same code {same} ({bytes_same} bytes); different {different} ({bytes_different_a} -> {bytes_different_b} bytes); '
              f'only in A {only_a} ({bytes_only_a} bytes); only in B {only_b} ({bytes_only_b} bytes)')
if len(sys.argv) > 4:
    open(sys.argv[4], 'w').write('\n'.join(changed) + '\n')
