#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# function_sizes.py [--top N] [--functions FILE.tsv] LOG...: the pipeline's time by function size, from the lap logs
# (laps.py; each function's times are the medians of the logs'). Prints the corpus's totals, the functions by size class
# of their lowered IR instructions (count, time, share, per function and per instruction), each phase's least-squares
# line over the functions (a fixed cost per function plus a cost per lowered IR instruction), and the top N functions.
# With --functions, writes every function's row: sizes and its milliseconds by phase.
import sys, statistics, collections
sys.path.insert(0, __import__('os').path.dirname(__file__))
import laps

PHASES = [
    ('lowering', ['lower.validate', 'lower.plan', 'lower.count', 'lower.emit', 'inline']),
    ('SSA construction', ['ssa.cfg', 'ssa.classify', 'ssa.prepare', 'ssa.definitions', 'ssa.construct', 'ssa.simplify', 'ssa.layout', 'ssa.fill']),
    ('passes', ['wide', 'vector-split', 'truth', 'if-convert', 'opt.cfg-uses', 'opt.dominators', 'opt.sccp', 'opt.dce', 'opt.rewrite']),
    ('verification', ['lower.verify', 'ssa.dominance', 'ssa.verify', 'opt.verify-input', 'opt.dominance', 'final.rows', 'final.cfg', 'final.dominators', 'final.dominance',
                      'alloc1.validate', 'alloc2.validate']),
    ('selection', ['select.prepare', 'select.facts', 'select.label', 'select.patterns', 'select.uses']),
    ('allocation 1', ['alloc1.prepare', 'alloc1.liveness', 'alloc1.lists', 'alloc1.intervals', 'alloc1.assign', 'alloc1.lookup', 'alloc1.edges']),
    ('allocation 2', ['alloc2.prepare', 'alloc2.liveness', 'alloc2.lists', 'alloc2.intervals', 'alloc2.assign', 'alloc2.lookup', 'alloc2.edges', 'cfg.callee']),
    ('emission', ['cfg.problem', 'cfg.saves', 'cfg.frame', 'cfg.records', 'chain.liveness', 'chain.prepare', 'chain.allocate', 'chain.frame', 'chain.records']),
    ('rest', ['arenas', 'publish', 'rest', 'other', 'gvn', 'certify']),
]

def fit(xs, ys):
    n = len(xs)
    mx, my = sum(xs) / n, sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    b = sxy / sxx if sxx else 0.0
    return my - b * mx, b

def main():
    args = sys.argv[1:]
    top, out = 10, None
    if '--top' in args:
        i = args.index('--top'); top = int(args[i + 1]); del args[i:i + 2]
    if '--functions' in args:
        i = args.index('--functions'); out = args[i + 1]; del args[i:i + 2]
    phase_of = {}
    for phase, names in PHASES:
        for name in names:
            phase_of[name] = phase
    logs = [laps.read(path) for path in args]
    functions = logs[0].functions
    per_run = []
    for log in logs:
        _, by_function = laps.totals(log)
        rows = {}
        for f, stages in by_function.items():
            if f == 0 or f not in functions:
                continue
            row = collections.Counter()
            for name, ticks in stages.items():
                if not name.startswith('driver.'):
                    row[phase_of.get(name, 'rest')] += ticks / log.ticks_per_ns / 1e6
            rows[f] = row
        per_run.append(rows)
    phases = [p for p, _ in PHASES]
    table = {}
    for f in functions:
        table[f] = {p: statistics.median(r.get(f, {}).get(p, 0.0) for r in per_run) for p in phases}
        table[f]['all'] = sum(table[f][p] for p in phases)
    ids = sorted(functions)
    total = sum(table[f]['all'] for f in ids)
    sums = {k: sum(functions[f][k] for f in ids) for k in laps.FUNCTION_FIELDS}
    print(f'# {len(logs)} logs, {len(ids)} functions, {sum(1 for f in ids if functions[f]["tier1"])} by Tier 1, {sum(1 for f in ids if functions[f]["chain"])} straight lines, '
          f'{sum(1 for f in ids if functions[f]["allocations"] >= 2)} allocated twice; the pipeline {total:.3f} ms')
    print('# sums: ' + ', '.join(f'{k} {sums[k]}' for k in ['typed_entries', 'lowered_instructions', 'lowered_blocks', 'promoted_locals', 'promoted_instructions', 'promoted_blocks',
                                                             'optimized_instructions', 'optimized_blocks', 'effective_uses', 'cfg_values', 'cfg_positions', 'cfg_phis', 'cfg_uses', 'dense_values', 'intervals', 'records', 'branches']))
    print(f'# per lowered IR instruction {1e6 * total / sums["lowered_instructions"]:.1f} ns, per optimized one {1e6 * total / sums["optimized_instructions"]:.1f} ns, per record {1e6 * total / sums["records"]:.1f} ns')
    print('\n## by size class (lowered IR instructions)')
    print('class\tfunctions\tlowered instructions\tms\tshare\tus per function\tns per instruction\t' + '\t'.join(phases))
    bounds = [0, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 1 << 30]
    for lo, hi in zip(bounds, bounds[1:]):
        mine = [f for f in ids if lo <= functions[f]['lowered_instructions'] < hi]
        if not mine:
            continue
        ms = sum(table[f]['all'] for f in mine)
        n = sum(functions[f]['lowered_instructions'] for f in mine)
        label = f'{lo} to {hi - 1}' if hi < (1 << 30) else f'{lo} and more'
        print(f'{label}\t{len(mine)}\t{n}\t{ms:.3f}\t{100 * ms / total:.1f}%\t{1e3 * ms / len(mine):.1f}\t{1e6 * ms / max(n, 1):.0f}\t' +
              '\t'.join(f'{100 * sum(table[f][p] for f in mine) / ms:.1f}%' for p in phases))
    print('\n## each phase as a line over the functions: a fixed cost per function and a cost per lowered IR instruction')
    print('phase\tms\tshare\tus per function (fixed)\tns per instruction\tfixed part of the phase')
    xs = [functions[f]['lowered_instructions'] for f in ids]
    for p in phases + ['all']:
        ys = [table[f][p] for f in ids]
        a, b = fit(xs, ys)
        s = sum(ys)
        print(f'{p}\t{s:.3f}\t{100 * s / total:.1f}%\t{1e3 * a:.2f}\t{1e6 * b:.1f}\t{100 * a * len(ids) / s if s else 0:.1f}%')
    print(f'\n## the {top} functions with the most time')
    print('function\tlowered instructions\tblocks\toptimized instructions\trecords\tcross-block values\tintervals\tallocations\tms\tshare\tns per lowered instruction\t' + '\t'.join(phases))
    for f in sorted(ids, key=lambda f: -table[f]['all'])[:top]:
        row = functions[f]
        ms = table[f]['all']
        print(f'{row["name"]}\t{row["lowered_instructions"]}\t{row["lowered_blocks"]}\t{row["optimized_instructions"]}\t{row["records"]}\t{row["dense_values"]}\t{row["intervals"]}\t{row["allocations"]}\t{ms:.3f}\t'
              f'{100 * ms / total:.1f}%\t{1e6 * ms / max(row["lowered_instructions"], 1):.0f}\t' + '\t'.join(f'{100 * table[f][p] / ms:.1f}%' for p in phases))
    if out:
        with open(out, 'w') as g:
            g.write('function\tname\t' + '\t'.join(laps.FUNCTION_FIELDS) + '\t' + '\t'.join(p + ' ms' for p in phases) + '\tall ms\n')
            for f in ids:
                row = functions[f]
                g.write(f'{f}\t{row["name"]}\t' + '\t'.join(str(row[k]) for k in laps.FUNCTION_FIELDS) + '\t' + '\t'.join(f'{table[f][p]:.5f}' for p in phases) + f'\t{table[f]["all"]:.5f}\n')

main()
