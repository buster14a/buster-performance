#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Summarize #1555's repeat from its per-run receipts (runs/NAME/): checks each run's receipts, then reports the
counters, profiles, the lexer variants' direct per-pass ratios, the refine phase and the probes.

Usage: python3 -I analyze.py RUNS_DIRECTORY
"""
from collections import defaultdict
from pathlib import Path
from statistics import median
import re
import sys

runs = Path(sys.argv[1])
problems = []


def receipt(name):
    d = runs / name
    status = (d / 'status').read_text().strip() if (d / 'status').exists() else None
    for f in ('command', 'requested', 'acquired', 'released', 'lock', 'stdout', 'stderr'):
        if not (d / f).exists():
            problems.append(f'{name}: no {f}')
    if status != '0':
        problems.append(f'{name}: status {status}')
    held = float((d / 'released').read_text()) - float((d / 'acquired').read_text()) if (d / 'released').exists() else None
    return d, held


def perf_csv(d):
    """perf stat -x, rows: value, unit, event, run time, percent running, ... -> {event: (value, percent)}."""
    values = {}
    for line in (d / 'perf.csv').read_text().splitlines():
        fields = line.split(',')
        if len(fields) < 5 or not fields[0] or line.startswith('#'):
            continue
        if not fields[0].isdigit():
            problems.append(f'{d.name}: {fields[2]} not counted ({fields[0]})')
            continue
        values[fields[2]] = (int(fields[0]), float(fields[4]) if fields[4] else None)
    return values


def stats(values):
    return f'median {median(values):,.0f} (min {min(values):,.0f}, max {max(values):,.0f}, n={len(values)})'


names = sorted(p.name for p in runs.iterdir() if p.is_dir() and (p / 'command').exists())
holds = []
for name in names:
    d, held = receipt(name)
    if held is not None:
        holds.append((held, name))
print(f'runs: {len(names)}; longest holds: ' + ', '.join(f'{n} {h:.1f} s' for h, n in sorted(holds)[-5:]))

# Counters: every process's events, with perf's running percentage.
counters = defaultdict(list)
percents = set()
for name in names:
    m = re.fullmatch(r'counters-r(\d+)-(\w+)-(sq-c|sq-syn)', name)
    if m:
        for event, (value, percent) in perf_csv(runs / name).items():
            counters[(m[2], m[3], event)].append(value)
            percents.add(percent)
print(f'\ncounters: perf running percentages seen: {sorted(percents)}')
for key in sorted(counters):
    print('  ' + ' '.join(key) + ': ' + stats(counters[key]))
for workload in ('sq-c', 'sq-syn'):
    for event in ('cycles:u', 'instructions:u', 'ls_misal_loads.ma64:u'):
        base = counters.get(('main', workload, event))
        for variant in ('lexer', 'refine'):
            other = counters.get((variant, workload, event))
            if base and other:
                change = median(other) / median(base) - 1
                overlap = not (max(other) < min(base) or min(other) > max(base))
                print(f'  {variant} vs main, {workload} {event}: {100 * change:+.2f}% of the median, ranges {"overlap" if overlap else "apart"}')

# Profiles: each run's total samples and the two functions' shares, from the whole report.
print('\nprofiles (perf record -e ls_misal_loads.ma64:u -c 997, whole reports):')
for name in names:
    m = re.fullmatch(r'report(-r\d+|1997)-(\w+)', name)
    if not m:
        continue
    text = (runs / name / 'stdout').read_text()
    samples = re.search(r'# Samples: (\S+) of event', text)
    shares = {}
    for line in text.splitlines():
        lm = re.match(r'\s*([\d.]+)%\s+\[\.\]\s+(\S+)', line)
        if lm and lm[2] in ('refine_pass_b_64_plain', 'tokenize_c_raw_no_separators'):
            shares[lm[2]] = float(lm[1])
    listed = sum(1 for line in text.splitlines() if re.match(r'\s*[\d.]+%\s+\[', line))
    throttles = re.search(r'THROTTLE events:\s+(\d+)', text)
    print(f'  {m[2]} {m[1].lstrip("-")}: {samples[1] if samples else "?"} samples, {listed} symbols listed, '
          f'{throttles[1] if throttles else "unreported"} throttle events; '
          + ', '.join(f'{k} {shares[k]:.2f}%' if k in shares else f'{k} not listed' for k in ('refine_pass_b_64_plain', 'tokenize_c_raw_no_separators')))

# The lexer variants: each pass's k1 cycles over control's in the same pass.
print('\nlexer variants (benchmark-lexer, k1 / control per pass):')
for name in names:
    if not name.startswith('lexer-variants-'):
        continue
    text = (runs / name / 'stdout').read_text()
    passes = {}
    for line in text.splitlines():
        if line.startswith('pass-cycles '):
            fields = line.split()
            passes[fields[1]] = [int(v) for v in fields[2:]]
    if 'k1' not in passes or 'control' not in passes:
        problems.append(f'{name}: no per-pass cycles')
        continue
    ratios = [k / c for k, c in zip(passes['k1'], passes['control'])]
    controls = [c / t for c, t in zip(passes['control'], passes['c_tokenize'])]
    differs = [line for line in text.splitlines() if 'differ' in line]
    print(f'  {name}: k1/control median {median(ratios):.4f} (min {min(ratios):.4f}, max {max(ratios):.4f}, '
          f'{sum(r > 1 for r in ratios)} of {len(ratios)} passes above 1); control/c_tokenize median {median(controls):.4f}; '
          + '; '.join(d.strip() for d in differs))

# The refine phase: benchmark-refinement's line for refine_tokens_64, as printed.
print('\nrefine phase (benchmark-refinement --only refine_tokens_64):')
for name in names:
    if name.startswith('refine-phase-'):
        lines = [l for l in (runs / name / 'stdout').read_text().splitlines() if 'refine_tokens_64' in l]
        print(f'  {name}: ' + (lines[-1].strip() if lines else '(no refine_tokens_64 line)'))

# Probes: medians over the three repetitions.
print('\nprobes (perf stat, three repetitions):')
probe = defaultdict(lambda: defaultdict(list))
for name in names:
    m = re.fullmatch(r'(probe[12]-[\d-]+)-r(\d)', name)
    if m:
        for event, (value, percent) in perf_csv(runs / name).items():
            probe[m[1]][event].append(value)
for config in sorted(probe):
    print(f'  {config}: ' + '; '.join(f'{e} {stats(v)}' for e, v in sorted(probe[config].items()) if e in ('cycles:u', 'ls_misal_loads.ma64:u')))

# Placements: each ab round's time-runs comparison, user cycles against main over placements and copies.
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
            m = re.match(r'  (lexer|refine|main-again): 12 runs.*against main ([-+\d.]+%) \(over placements ([-+\d.]+% to [-+\d.]+%)', line)
            if m and block in (2, 4):
                print(f'  round {round_no} {"-c" if block == 2 else "-fsyntax-only":14} {m[1]:11} {m[2]:>7} (over placements {m[3]})')

print('\nproblems: ' + ('none' if not problems else '\n  ' + '\n  '.join(problems)))
