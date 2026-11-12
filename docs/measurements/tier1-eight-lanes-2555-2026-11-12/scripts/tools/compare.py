#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# compare.py FIRST ROUND1 ROUND2: baseline3.sh's rows of the first record (FIRST, its raw/baseline3 directory) against
# this record's two rounds (raw/round1, raw/round2): per corpus, lanes and configuration, the median wall time with
# its range, user and kernel cycles and user instructions (runs.tsv, under perf). Prints two Markdown tables: the
# eight-lane rows (all three) and the one-lane rows (the first record and round 1, the control).
import sys, os

def medians(path):
    out = {}
    header = None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p
            continue
        if p[0] in ('median', 'low', 'high'):
            out[(p[0], p[3])] = dict(zip(header[5:], (float(x) for x in p[5:])))
    return out

def cell(r, config):
    m, lo, hi = r[('median', config)], r[('low', config)], r[('high', config)]
    return m, f"{m['wall_ms']:,.1f} ({lo['wall_ms']:,.1f} to {hi['wall_ms']:,.1f})"

def change(a, b):
    return f"{(b / a - 1) * 100:+.1f}%".replace("-", "\u2212")

first, round1, round2 = sys.argv[1:4]
names = {'sqlite': '`sqlite3.c`', 'lua': 'Lua, 33 units', 'musl': 'musl, 1,336 units'}
configs = {'default': 'default', 'tier1': '`--tier1`'}
print('Eight lanes (CPUs 0 to 7): wall ms, median (range); then user cycles, kernel cycles and user instructions, M.')
print()
print('| corpus | compile | first record, beside the stray | round 1, clear | round 2, clear | wall, round 1 against the first | user cycles: first, round 1, round 2 | kernel cycles: first, round 1, round 2 | user instructions: first, round 1, round 2 |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
for name in ('sqlite', 'lua', 'musl'):
    a = medians(os.path.join(first, f'{name}-8', 'runs.tsv'))
    b = medians(os.path.join(round1, f'{name}-8', 'runs.tsv'))
    c = medians(os.path.join(round2, f'{name}-8', 'runs.tsv'))
    for config in ('default', 'tier1'):
        am, at = cell(a, config)
        bm, bt = cell(b, config)
        cm, ct = cell(c, config)
        uc = ', '.join(f"{x['user_cycles'] / 1e6:,.1f}" for x in (am, bm, cm))
        kc = ', '.join(f"{x['kernel_cycles'] / 1e6:,.1f}" for x in (am, bm, cm))
        ui = ', '.join(f"{x['user_instructions'] / 1e6:,.1f}" for x in (am, bm, cm))
        print(f"| {names[name]} | {configs[config]} | {at} | {bt} | {ct} | {change(am['wall_ms'], bm['wall_ms'])} | {uc} | {kc} | {ui} |")
print()
print('One lane (CPU 2), the control: wall ms, median (range); user cycles and user instructions, M.')
print()
print('| corpus | compile | first record | round 1, clear | wall | user cycles: first, round 1 | user cycles | user instructions: first, round 1 |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |')
for name in ('sqlite', 'lua', 'musl'):
    a = medians(os.path.join(first, f'{name}-1', 'runs.tsv'))
    b = medians(os.path.join(round1, f'{name}-1', 'runs.tsv'))
    for config in ('default', 'tier1'):
        am, at = cell(a, config)
        bm, bt = cell(b, config)
        uc = ', '.join(f"{x['user_cycles'] / 1e6:,.1f}" for x in (am, bm))
        ui = ', '.join(f"{x['user_instructions'] / 1e6:,.1f}" for x in (am, bm))
        print(f"| {names[name]} | {configs[config]} | {at} | {bt} | {change(am['wall_ms'], bm['wall_ms'])} | {uc} | {change(am['user_cycles'], bm['user_cycles'])} | {ui} |")
