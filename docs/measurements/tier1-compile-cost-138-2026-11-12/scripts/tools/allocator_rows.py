#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# allocator_rows.py VARIANTS.tsv: variants.py's table as the allocator's rows by what they do, in Markdown: the parts up
# to the intervals in the first call and in the second, the plain assignment (alloc1.assign: whole, a verdict's call, or
# only the functions with nothing to prefer), the preferred one (alloc2.assign), lookup with slot sharing and the edge
# moves (both calls': in the one-call orders the first call's rows are the allocation's that stands), the callee-saved
# step, their sum and the pipeline.
import sys

rows, order = {}, None
for line in open(sys.argv[1]):
    if line.startswith('#'):
        continue
    p = line.rstrip('\n').split('\t')
    if order is None:
        order = [c[:-3] for c in p[1:] if c.endswith(' ms')]
        continue
    rows[p[0]] = [float(p[1])] + [float(p[k]) for k in range(2, len(p), 2)]

def total(names):
    return [sum(rows[n][k] for n in names if n in rows) for k in range(len(order))]

FRONT = ['validate', 'prepare', 'liveness', 'lists', 'intervals']
table = [
    ('validation to intervals, the first call', total([f'alloc1.{n}' for n in FRONT])),
    ('validation to intervals, the second call', total([f'alloc2.{n}' for n in FRONT])),
    ('the plain assignment, or its verdict', total(['alloc1.assign'])),
    ('the preferred assignment', total(['alloc2.assign'])),
    ('lookup columns and slot sharing', total(['alloc1.lookup', 'alloc2.lookup'])),
    ('edge moves', total(['alloc1.edges', 'alloc2.edges'])),
    ('the callee-saved step', total(['cfg.callee'])),
    ('**the allocator**', rows['the allocator (alloc1, alloc2, cfg.callee)']),
    ('**the pipeline**', rows['the pipeline']),
]
print('| ms | ' + ' | '.join(order) + ' |')
print('| --- |' + ' ---: |' * len(order))
for name, values in table:
    print(f'| {name} | ' + ' | '.join(f'{v:.1f}' for v in values) + ' |')
