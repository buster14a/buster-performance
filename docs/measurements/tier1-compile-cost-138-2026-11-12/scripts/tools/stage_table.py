#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_table.py [--groups] LOG...: each stage's milliseconds, the median of the runs' lap logs (laps.py), with the
# pipeline's stages first (those of laps.patch), their total, and the driver's stages. With --groups, the pipeline's
# stages summed by laps.py's groups. Ticks become milliseconds at each log's own TSC rate.
import sys, statistics, collections
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

def main():
    args = sys.argv[1:]
    groups = '--groups' in args
    if groups: args.remove('--groups')
    runs = []
    for path in args:
        log = laps.read(path)
        by_stage, _ = laps.totals(log)
        runs.append({name: ticks / log.ticks_per_ns / 1e6 for name, ticks in by_stage.items()})
        order = [log.stages[k] for k in sorted(log.stages)]
        functions = len(log.functions)
    names = [n for n in order if any(n in r for r in runs)]
    med = {n: statistics.median(r.get(n, 0.0) for r in runs) for n in names}
    low = {n: min(r.get(n, 0.0) for r in runs) for n in names}
    high = {n: max(r.get(n, 0.0) for r in runs) for n in names}
    pipeline = [n for n in names if not n.startswith('driver.')]
    pipeline_total = statistics.median(sum(r.get(n, 0.0) for n in pipeline) for r in runs)
    whole = statistics.median(sum(r.values()) for r in runs)
    print(f'# {len(runs)} runs, {functions} functions; the pipeline {pipeline_total:.3f} ms of {whole:.3f} ms between the first lap and the last')
    if groups:
        table = laps.group_of()
        sums = collections.OrderedDict((g, []) for g, _ in laps.GROUPS)
        for r in runs:
            per = collections.Counter()
            for n in pipeline:
                per[table.get(n, 'publication and the rest')] += r.get(n, 0.0)
            for g in sums:
                sums[g].append(per[g])
        print('group\tms\tlow\thigh\tshare of the pipeline')
        for g, values in sums.items():
            m = statistics.median(values)
            if m > 0:
                print(f'{g}\t{m:.3f}\t{min(values):.3f}\t{max(values):.3f}\t{100 * m / pipeline_total:.1f}%')
        print(f'the pipeline\t{pipeline_total:.3f}')
    else:
        print('stage\tms\tlow\thigh\tshare of the pipeline')
        for n in pipeline:
            print(f'{n}\t{med[n]:.3f}\t{low[n]:.3f}\t{high[n]:.3f}\t{100 * med[n] / pipeline_total:.1f}%')
        print(f'the pipeline\t{pipeline_total:.3f}')
        for n in names:
            if n.startswith('driver.'):
                print(f'{n}\t{med[n]:.3f}\t{low[n]:.3f}\t{high[n]:.3f}\t')
        print(f'all laps\t{whole:.3f}')

main()
