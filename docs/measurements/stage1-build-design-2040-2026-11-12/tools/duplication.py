#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# duplication.py MAPS_DIRECTORY: how often the build compiles one function, from function_files' maps of every unit's
# unoptimized bitcode (maps-all.sh). A function is its name, file and line; clang emits a static function in every unit
# whose emitted code refers to it, so the same definition is optimized once per unit that uses it. Prints, for the
# eleven main.c units and for the 32 units of their own (benchmarks, measurements, tools) apart and together: the
# definitions emitted, the distinct ones, and both in unoptimized instructions; then each unit's own count and how much
# of it another unit of the same group also compiles.
import collections
import os
import re
import sys

directory = sys.argv[1]
units = {}
for name in sorted(os.listdir(directory)):
    if name.endswith('.functions.tsv'):
        rows = {}
        for line in open(os.path.join(directory, name)):
            function, path, line_number, linkage, count, _used = line.rstrip('\n').split('\t')
            if linkage != 'available_externally':
                rows[(function, os.path.basename(path), line_number)] = int(count)
        units[name[:-len('.functions.tsv')]] = rows


def kind_of(base):
    if re.search(r'_test(_|\.)|_tests?\.|test_|fuzz', base):
        return 'test'
    if 'benchmark' in base or '_measure' in base:
        return 'benchmark'
    return 'product'


def report(title, names):
    emitted = collections.Counter()
    weight = {}
    for unit in names:
        for key, count in units[unit].items():
            emitted[key] += 1
            weight[key] = count
    total = sum(weight[k] * n for k, n in emitted.items())
    distinct = sum(weight.values())
    print(f'{title}: {len(names)} units, {sum(emitted.values())} definitions emitted ({total} unoptimized instructions), '
          f'{len(emitted)} distinct ({distinct} instructions): {100 * (total - distinct) / total:.1f}% of the emitted instructions are further copies')
    by_kind = collections.Counter()
    by_kind_distinct = collections.Counter()
    for key, n in emitted.items():
        by_kind[kind_of(key[1])] += weight[key] * n
        by_kind_distinct[kind_of(key[1])] += weight[key]
    for kind in ('product', 'test', 'benchmark'):
        if by_kind[kind]:
            print(f'    {kind:9s} {by_kind[kind]:9d} emitted, {by_kind_distinct[kind]:9d} distinct ({by_kind[kind] / by_kind_distinct[kind]:.2f} copies on average)')
    return emitted, weight


main_units = [u for u in units if u == 'main' or u.startswith('main_unit_')]
others = [u for u in units if u not in main_units]
main_emitted, _ = report('the main.c units', main_units)
report('the units of their own', others)
report('all units', list(units))
print('\nunit\tdefinitions\tinstructions\tinstructions a main.c unit also compiles\tshare')
for unit in sorted(units, key=lambda u: -sum(units[u].values())):
    rows = units[unit]
    total = sum(rows.values())
    if unit in main_units:
        shared = sum(count for key, count in rows.items() if main_emitted[key] > 1)
    else:
        shared = sum(count for key, count in rows.items() if main_emitted[key] > 0)
    print(f'{unit}\t{len(rows)}\t{total}\t{shared}\t{100 * shared / max(total, 1):.1f}%')
