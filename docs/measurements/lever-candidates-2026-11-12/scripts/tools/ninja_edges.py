#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# ninja_edges.py NINJA_LOG: the stage 1 build's edges from ninja's log (the last run of each output, an edge with two
# outputs once): their time by kind, and the longest.
import sys

edges = {}
for line in open(sys.argv[1]):
    if line.startswith('#'):
        continue
    start, end, _mtime, output, command = line.rstrip('\n').split('\t')
    edges[output] = (int(start), int(end), command)
unique = {}
for output, key in edges.items():
    unique.setdefault(key, output)
kinds = {'the unity units, front end and -O3 to bitcode': 0, "the units' backend parts": 0, 'benchmark and tool objects, and main.c': 0, 'the rest (split tool, link, bake)': 0}
for (start, end, _command), output in unique.items():
    duration = end - start
    if 'main_unit_' in output and output.endswith('.c.o'):
        kinds['the unity units, front end and -O3 to bitcode'] += duration
    elif '/codegen/' in output:
        kinds["the units' backend parts"] += duration
    elif output.endswith('.c.o'):
        kinds['benchmark and tool objects, and main.c'] += duration
    else:
        kinds['the rest (split tool, link, bake)'] += duration
total = sum(end - start for (start, end, _c) in unique)
print(f'{len(unique)} edges, {total / 1000:.1f} s of edge time')
for kind, duration in kinds.items():
    print(f'{duration / 1000:8.1f} s  {kind}')
print('the longest edges:')
for duration, output in sorted(((end - start, output) for (start, end, _c), output in unique.items()), reverse=True)[:24]:
    print(f'{duration / 1000:8.1f} s  {output.split("/Release/")[-1][-90:]}')
