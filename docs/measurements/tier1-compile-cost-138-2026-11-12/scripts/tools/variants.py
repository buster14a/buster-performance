#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# variants.py DIRECTORY VARIANT...: a prototype's lap logs (DIRECTORY/VARIANT-K.laps.gz, or VARIANT.laps.gz) as one table of the
# pipeline's stages, a column a variant: each stage's milliseconds (the median of the variant's logs) and, for every
# variant after the first, its difference from the first. The last rows are the pipeline's stages together, the
# allocator's (both calls and the callee-saved step), and the whole compile between the first lap and the last.
import sys, os, glob, statistics, collections
sys.path.insert(0, os.path.dirname(__file__))
import laps

def stage_ms(path):
    log = laps.read(path)
    by_stage, _ = laps.totals(log)
    ms = {name: ticks / log.ticks_per_ns / 1e6 for name, ticks in by_stage.items()}
    return ms, (log.tsc[-1] - log.anchor[0]) / log.ticks_per_ns / 1e6

def main():
    directory, variants = sys.argv[1], sys.argv[2:]
    table, whole, order = {}, {}, []
    for v in variants:
        paths = sorted(glob.glob(os.path.join(directory, f'{v}-*.laps.*'))) or sorted(glob.glob(os.path.join(directory, f'{v}.laps.*')))
        runs = [stage_ms(p) for p in paths]
        names = []
        for ms, _ in runs:
            for name in ms:
                if name not in names:
                    names.append(name)
        table[v] = {name: statistics.median(ms.get(name, 0.0) for ms, _ in runs) for name in names}
        whole[v] = statistics.median(w for _, w in runs)
        for name in names:
            if name not in order:
                order.append(name)
        print(f'# {v}: {len(paths)} logs')
    pipeline = [n for n in order if not n.startswith('driver.')]
    allocator = [n for n in pipeline if n.startswith('alloc1.') or n.startswith('alloc2.') or n == 'cfg.callee']
    first = variants[0]
    print('stage\t' + '\t'.join([f'{first} ms'] + [f'{v} ms\t{v} - {first}' for v in variants[1:]]))
    def row(label, value):
        cells = [f'{value(first):.3f}']
        for v in variants[1:]:
            cells += [f'{value(v):.3f}', f'{value(v) - value(first):+.3f}']
        print(label + '\t' + '\t'.join(cells))
    for name in pipeline:
        row(name, lambda v, name=name: table[v].get(name, 0.0))
    row('the pipeline', lambda v: sum(table[v].get(n, 0.0) for n in pipeline))
    row('the allocator (alloc1, alloc2, cfg.callee)', lambda v: sum(table[v].get(n, 0.0) for n in allocator))
    row('the compile', lambda v: whole[v])

main()
