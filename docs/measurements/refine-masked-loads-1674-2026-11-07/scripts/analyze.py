#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Summarize #1674's campaign from its per-run receipts (runs/NAME/): checks each run's receipts, then reports the
outputs, the counters, the refine phase at every placement (the head and main again against main at the same
placement and round) and the whole drivers over placements.

Usage: python3 -I analyze.py RUNS_DIRECTORY
"""
from collections import defaultdict
from pathlib import Path
from statistics import median
import re
import sys

runs = Path(sys.argv[1])
problems = []
names = sorted(p.name for p in runs.iterdir() if p.is_dir() and (p / 'command').exists())
holds = []
for name in names:
    d = runs / name
    for f in ('command', 'requested', 'acquired', 'released', 'lock', 'stdout', 'stderr', 'status'):
        if not (d / f).exists():
            problems.append(f'{name}: no {f}')
    status = (d / 'status').read_text().strip() if (d / 'status').exists() else None
    if status != '0':
        problems.append(f'{name}: status {status}')
    if (d / 'released').exists() and (d / 'acquired').exists():
        holds.append((float((d / 'released').read_text()) - float((d / 'acquired').read_text()), name))
print(f'runs: {len(names)}; longest holds: ' + ', '.join(f'{n} {h:.1f} s' for h, n in sorted(holds)[-4:]))
if (runs / 'outputs-compared').exists():
    print('\noutputs:\n  ' + '\n  '.join((runs / 'outputs-compared').read_text().splitlines()))

# Counters.
counters = defaultdict(list)
percents = set()
for name in names:
    m = re.fullmatch(r'counters-r(\d+)-(main|head)-sq-c', name)
    if not m:
        continue
    for line in (runs / name / 'perf.csv').read_text().splitlines():
        fields = line.split(',')
        if len(fields) >= 5 and fields[0].isdigit():
            counters[(m[2], fields[2])].append(int(fields[0]))
            percents.add(float(fields[4]))
        elif len(fields) >= 5 and not line.startswith('#') and fields[0]:
            problems.append(f'{name}: {fields[2]} not counted ({fields[0]})')
if counters:
    print(f'\ncounters (-c, perf running percentages seen: {sorted(percents)}):')
    for event in sorted({e for _, e in counters}):
        a, b = counters[('main', event)], counters[('head', event)]
        apart = max(b) < min(a) or min(b) > max(a)
        print(f'  {event}: main median {median(a):,.0f} ({min(a):,.0f}-{max(a):,.0f}), head median {median(b):,.0f} '
              f'({min(b):,.0f}-{max(b):,.0f}), {100 * (median(b) / median(a) - 1):+.2f}%, ranges {"apart" if apart else "overlap"}')

# The refine phase: cycles per token at each placement and round.
phase = {}
for name in names:
    m = re.fullmatch(r'phase-(\w+?)-r(\d+)-p(\d+)-(main|head|main-again)', name)
    if not m or not (runs / name / 'status').exists():
        continue
    line = next((l for l in (runs / name / 'stdout').read_text().splitlines() if l.strip().startswith('refine_tokens_64')), None)
    v = re.search(r'([\d.]+) cycles/token', line or '')
    i = re.search(r'([\d.]+) instructions/token', line or '')
    t = re.search(r'([\d.]+) ms', line or '')
    if not v:
        problems.append(f'{name}: no refine_tokens_64 line')
        continue
    phase[(m[1], int(m[2]), int(m[3]), m[4])] = (float(v[1]), float(i[1]), float(t[1]))
if phase:
    print('\nrefine phase (benchmark-refinement --only refine_tokens_64), each against main at the same placement and round:')
    for corpus in sorted({k[0] for k in phase}):
        for build in ('head', 'main-again'):
            ratios = []
            for (c, r, p, b), (cycles, _, _) in sorted(phase.items()):
                if c == corpus and b == build and (c, r, p, 'main') in phase:
                    ratios.append(cycles / phase[(c, r, p, 'main')][0])
            if ratios:
                print(f'  {corpus} {build}/main cycles per token: median {median(ratios):.4f} (min {min(ratios):.4f}, '
                      f'max {max(ratios):.4f}, {sum(x < 1 for x in ratios)} of {len(ratios)} below 1)')
        for build in ('main', 'head', 'main-again'):
            values = [v for (c, _, _, b), v in phase.items() if c == corpus and b == build]
            if values:
                print(f'  {corpus} {build}: cycles per token median {median(v[0] for v in values):.3f} '
                      f'({min(v[0] for v in values):.3f}-{max(v[0] for v in values):.3f}), instructions per token '
                      f'{sorted({v[1] for v in values})}, time median {median(v[2] for v in values):.3f} ms')

# The whole drivers over placements.
log = runs / 'placements' / 'ab.log'
if log.exists():
    print('\nplacements (ab: one time-runs process per lock hold; user cycles against main):')
    round_no = 0
    block = 0
    for line in log.read_text().splitlines():
        if line.startswith('== round'):
            round_no += 1
            block = 0
        elif line.startswith('  main: 12 runs'):
            block += 1
        else:
            m = re.match(r'  (head|main-again): 12 runs.*against main ([-+\d.]+%) \(over placements ([-+\d.]+% to [-+\d.]+%)', line)
            if m and block in (2, 4):
                print(f'  round {round_no} {"-c" if block == 2 else "-fsyntax-only":14} {m[1]:11} {m[2]:>7} (over placements {m[3]})')

print('\nproblems: ' + ('none' if not problems else '\n  ' + '\n  '.join(problems)))
