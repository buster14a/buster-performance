#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# reach.py FUNCTIONS.tsv EDGES.tsv OUTPUT_PREFIX: which of a unit's functions the product needs, from function_files'
# map of its unoptimized bitcode. The roots are the unit's external definitions and what llvm.used names; the product's
# functions are those the roots reach through references without entering a function written in a test, benchmark or
# measurement file (unit_lines.py's rule for tests: _test, test_, _tests, fuzz; "benchmark" and "_measure" in the name
# for the others). The rest is what a unit without its tests would not compile: the test files' own functions, and the
# product files' functions that only tests, benchmarks or measurements reach.
# Writes OUTPUT_PREFIX.product.txt (the product's functions), OUTPUT_PREFIX.rest.txt (the others), OUTPUT_PREFIX.tests.csv
# (the test files' functions as forceattrs lines: NAME,optnone and NAME,noinline) and prints the counts.
import collections
import os
import re
import sys

functions_path, edges_path, prefix = sys.argv[1:4]


def kind_of(base):
    if re.search(r'_test(_|\.)|_tests?\.|test_|fuzz', base):
        return 'test'
    if 'benchmark' in base:
        return 'benchmark'
    if '_measure' in base:
        return 'measure'
    return 'product'


functions = {}
for line in open(functions_path):
    name, path, _line, linkage, count, used = line.rstrip('\n').split('\t')
    functions[name] = (os.path.basename(path), linkage, int(count), used == '1')
edges = collections.defaultdict(set)
for line in open(edges_path):
    source, target = line.rstrip('\n').split('\t')
    edges[source].add(target)

roots = ['F ' + name for name, (_file, linkage, _count, used) in functions.items() if linkage == 'external' or used]
reached = set()
stack = list(roots)
while stack:
    node = stack.pop()
    if node in reached:
        continue
    if node.startswith('F '):
        entry = functions.get(node[2:])
        if entry is None or (kind_of(entry[0]) != 'product'):
            continue
    reached.add(node)
    stack.extend(edges.get(node, ()))
product = {node[2:] for node in reached if node.startswith('F ')}

rows = collections.Counter()
instructions = collections.Counter()
for name, (base, linkage, count, _used) in functions.items():
    if linkage == 'available_externally':
        group = 'available_externally (another unit emits them)'
    elif name in product:
        group = 'product: reached from the unit\'s entry points without a test'
    elif kind_of(base) == 'product':
        group = 'product files\' functions that only tests, benchmarks or measurements reach'
    else:
        group = kind_of(base) + ' files\' functions'
    rows[group] += 1
    instructions[group] += count
total = sum(instructions.values())
print(f'{len(functions)} function definitions, {total} unoptimized instructions; {len(roots)} roots')
for group in sorted(rows, key=lambda g: -instructions[g]):
    print(f'  {rows[group]:6d} functions  {instructions[group]:9d} instructions  {100 * instructions[group] / total:5.1f}%  {group}')
with open(prefix + '.product.txt', 'w') as out:
    out.write(''.join(name + '\n' for name in sorted(product)))
with open(prefix + '.rest.txt', 'w') as out:
    out.write(''.join(name + '\n' for name, entry in sorted(functions.items()) if name not in product and entry[1] != 'available_externally'))
with open(prefix + '.tests.csv', 'w') as out:
    for name, (base, linkage, _count, _used) in sorted(functions.items()):
        if kind_of(base) == 'test' and linkage != 'available_externally':
            out.write(f'{name},optnone\n{name},noinline\n')
