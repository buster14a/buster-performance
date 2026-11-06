#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Summarize retained rows; does not verify machine locking or build provenance."""
from collections import defaultdict
from decimal import Decimal
import hashlib
from pathlib import Path
import re
from statistics import median

root = Path(__file__).resolve().parent


def require(ok, message):
    if not ok:
        raise ValueError(message)


fixture_names = set()
for line in (root / 'k.sha256').read_text().splitlines():
    digest, name = line.split('  ', 1)
    require(name in {'k/driver.c', 'k/kernel.c', 'k/sz.c', 'k/szdrv.c'} and name not in fixture_names, 'unexpected or duplicate fixture name')
    fixture_names.add(name)
    require(hashlib.sha256((root / name).read_bytes()).hexdigest() == digest, 'fixture hash mismatch: ' + name)
require(len(fixture_names) == 4, 'fixture count')


def summarize(name, versions, metrics, check_value):
    rows = defaultdict(list)
    seen = set()
    data = root / 'results/run-1793987627' / name
    for line in data.read_text().splitlines():
        fields = line.split()
        require(len(fields) == 4, 'malformed row: ' + line)
        round_text, version, metric, value = fields
        require(round_text in {'1', '2', '3', '4', '5'} and version in versions and metric in metrics | {'check'}, 'unexpected row: ' + line)
        key = (round_text, version, metric)
        require(key not in seen, 'duplicate row: ' + line)
        seen.add(key)
        if metric == 'check':
            require(value == check_value, 'check total mismatch: ' + line)
        else:
            n = Decimal(value)
            require(n.is_finite() and n >= 0, 'invalid duration')
            rows[(version, metric)].append(n)
    require(len(seen) == 5 * len(versions) * (len(metrics) + 1), 'incomplete rows: ' + name)
    for version in sorted(versions):
        for metric in sorted(metrics):
            values = rows[(version, metric)]
            require(len(values) == 5, 'missing values')
            print(f'{name}\t{version}\t{metric}\t{median(values):.3f}')


summarize('kernels.txt', {'base-t0','head-t0','base-t1','head-t1','clang-o0','clang-o2'},
          {'array','partial','struct','literal','copy','return'}, '13921875656250')
summarize('sizes.txt', {'base-t0','head-t0','fill8-t0','base-t1','head-t1','fill8-t1','clang-o0'},
          {'size16','size32','size64','size96','size128','size136','size192','size256'}, '97499920000000')

runs = defaultdict(list)
seen = set()
pattern = re.compile(r'^run (\d+) list 1 (base|head): ([0-9.]+) ms wall, .*?, (\d+) user cycles, (\d+) instructions, status (\d+)$')
for line in (root / 'results/compile-1793987650/time-runs.txt').read_text().splitlines():
    if not line.startswith('run '):
        continue
    match = pattern.fullmatch(line)
    require(match is not None, 'malformed compile run')
    number, version, wall, cycles, instructions, status = match.groups()
    key = (int(number), version)
    require(1 <= key[0] <= 21 and key not in seen and status == '0', 'invalid compile run/status')
    seen.add(key)
    runs[(version, 'wall-ms')].append(Decimal(wall))
    runs[(version, 'cycles')].append(int(cycles))
    runs[(version, 'instructions')].append(int(instructions))
require(len(seen) == 42, 'incomplete compile runs')
for version in ('base', 'head'):
    for metric in ('wall-ms', 'cycles', 'instructions'):
        print(f'compile\t{version}\t{metric}\t{median(runs[(version, metric)])}')
print('PASS retained rows and fixture hashes; no lock or build-provenance claim')
