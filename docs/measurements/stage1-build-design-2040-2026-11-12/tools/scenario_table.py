#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# scenario_table.py RESULTS.txt LOGS_DIRECTORY SET: the scenarios of one set of builds (run.sh's lines in RESULTS.txt and
# the lines Ninja's log gained in each, LOGS_DIRECTORY/SET-CASE-REP.ninja_log): for each scenario, every run's wall and
# CPU time and the median, and from the median run's log the commands that reran, by kind, with their summed time and
# the longest. A command with several outputs is one command. Prints a table of tab-separated rows.
import collections
import os
import statistics
import sys

results, logs, name = sys.argv[1:4]


def kind_of(output):
    base = output.split('/')[-1]
    if '/codegen/' in output or output.startswith('Release/codegen/'):
        if base in ('split.stamp', 'exports.txt', 'locals.txt') or base.endswith('.bc'):
            return 'split'
        if base == 'native.o':
            return 'join'
        return 'part'
    if base.endswith('.c.o'):
        return 'unit'
    if base == 'compiler.link' or base.endswith('.link'):
        return 'link'
    if base == 'compiler' or base.startswith('compiler-'):
        return 'bake'
    if base == 'split' and 'codegen-tools' in output:
        return 'tool'
    return 'other'


def edges_of(path):
    edges = {}
    if os.path.exists(path):
        for line in open(path):
            if line.startswith('#') or not line.strip():
                continue
            start, end, _mtime, output, digest = line.rstrip('\n').split('\t')
            key = (int(start), int(end), digest)
            kind = kind_of(output)
            if key not in edges or kind != 'split':
                edges[key] = (kind, output)
    return edges


cases = collections.OrderedDict()
for line in open(results):
    fields = line.split('|')[0].split()
    if len(fields) < 6 or not fields[2].isdigit():
        continue
    case, _tree, rep, wall, user, system = fields[:6]
    status = [f for f in fields if f.startswith('rc=')]
    if rep == '0' and case not in ('restore',):
        # The first build of a fresh clone: a warm-up, kept apart.
        case = case + ' (first)'
    cases.setdefault(case, []).append((int(rep), float(wall), float(user) + float(system), status[0] if status else ''))

kinds = ['unit', 'split', 'part', 'join', 'link', 'bake', 'tool', 'other']
print('scenario\truns\twall s (each)\twall s median\tCPU s median\tcommands\t' + '\t'.join(f'{k}: n, sum s, max s' for k in kinds) + '\tlongest units')
for case, every in cases.items():
    # A failed build's time is no build's time: it is named at the row's end and left out of the medians.
    runs = [r for r in every if r[3] == 'rc=0'] or every
    walls = [r[1] for r in runs]
    median = statistics.median_low(walls)
    chosen = next(r for r in runs if r[1] == median)
    edges = edges_of(os.path.join(logs, f"{name}-{case.replace(' (first)', '')}-{chosen[0]}.ninja_log"))
    by_kind = collections.defaultdict(list)
    units = []
    for (start, end, _digest), (kind, output) in edges.items():
        by_kind[kind].append((end - start) / 1000)
        if kind == 'unit':
            units.append(((end - start) / 1000, output.split('/')[-1][:-4]))
    cells = []
    for kind in kinds:
        times = by_kind.get(kind, [])
        cells.append(f'{len(times)}, {sum(times):.1f}, {max(times):.1f}' if times else '')
    longest = ', '.join(f'{n} {t:.1f}' for t, n in sorted(units, reverse=True)[:3])
    failed = [r for r in every if r[3] != 'rc=0']
    print(f"{case}\t{len(runs)}\t{' '.join(f'{w:.1f}' for w in walls)}\t{median:.1f}\t{statistics.median_low([r[2] for r in runs]):.1f}\t{len(edges)}\t" + '\t'.join(cells) + f'\t{longest}' + (f'\tFAILED {failed}' if failed else ''))
