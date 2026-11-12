#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_by_size.py LOG...: each of the pipeline's stages' nanoseconds per lowered IR instruction by the function's size
# class (the lap logs' medians per function, laps.py), and the ratio of the smallest class's to the largest's: what a
# stage costs per instruction when it runs for a few instructions at a time against when it runs for thousands.
import sys, statistics, collections
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

BOUNDS = [0, 32, 64, 128, 256, 512, 1024, 2048, 4096, 1 << 30]

def main():
    logs = [laps.read(p) for p in sys.argv[1:]]
    functions = logs[0].functions
    per = []
    for log in logs:
        _, by_function = laps.totals(log)
        per.append({f: {n: t / log.ticks_per_ns for n, t in s.items()} for f, s in by_function.items()})
    order = [logs[0].stages[k] for k in sorted(logs[0].stages) if k < laps.DRIVER]
    classes = collections.defaultdict(list)
    for f, row in functions.items():
        classes[max(b for b in BOUNDS if b <= row['lowered_instructions'])].append(f)
    labels = [f'{lo} to {hi - 1}' if hi < (1 << 30) else f'{lo} and more' for lo, hi in zip(BOUNDS, BOUNDS[1:]) if lo in classes]
    print('stage\tms\t' + '\t'.join(labels) + '\tsmallest / largest')
    for name in order:
        cells = []
        total = 0.0
        for lo in BOUNDS[:-1]:
            if lo not in classes:
                continue
            ns = sum(statistics.median(r.get(f, {}).get(name, 0.0) for r in per) for f in classes[lo])
            n = sum(functions[f]['lowered_instructions'] for f in classes[lo])
            cells.append(ns / max(n, 1))
            total += ns
        if total < 0.5e6:
            continue
        ratio = cells[0] / cells[-1] if cells[-1] > 0 else float('nan')
        print(f'{name}\t{total / 1e6:.2f}\t' + '\t'.join(f'{c:.1f}' for c in cells) + f'\t{ratio:.1f}')

main()
