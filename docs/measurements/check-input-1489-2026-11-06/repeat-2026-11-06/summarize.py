#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Validate and summarize the retained, separately locked historical-head repeat."""
from pathlib import Path
from statistics import mean, median
import hashlib
import re
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: summarize.py EXTRACTED_DATA_DIRECTORY')
root = Path(sys.argv[1])
raw = root / 'raw'
names = ('pre1049', 'rbase', 'rhead')
labels = []
for r in range(11):
    labels.extend(f'sq-{names[(j+r)%3]}-{r}' for j in range(3))
for r in range(5):
    labels.extend(f'perf-{names[(j+r)%3]}-{r}' for j in range(3))
for r in range(3):
    labels.extend(f'self-{names[1+(j+r)%2]}-{r}' for j in range(2))
rows = [line.split('\t') for line in (root / 'status.tsv').read_text().splitlines()]
assert len(rows) == 54 and [r[0] for r in rows] == labels and all(r[1:] == ['0'] for r in rows)
assert (root / 'failure').read_text().strip() == '0'
assert (root / 'inputs-before.sha256').read_bytes() == (root / 'inputs-after.sha256').read_bytes()
expected_binaries = (
    '8c0869bd6e2349fd49865d73541dcc2bcc5002b978ab3b3c410433bff11a0c38',
    '306994c65597df3a51d49b13c7b692f2825689071b4d370c220bee5f3638eac0',
    '731f2adc08f3669ec0a09f0e9cd80746d131a3ee2f753894345930f1ec6ed6b6',
)
assert tuple(line.split()[0] for line in (root / 'expected-binaries.sha256').read_text().splitlines()) == expected_binaries
before = (root / 'binaries-before.txt').read_text().splitlines()
assert len(before) == 3 and all(line.endswith(': OK') for line in before)
assert (root / 'binaries-before.txt').read_bytes() == (root / 'binaries-after.txt').read_bytes()
inputs = [line.split('  ', 1)[0] for line in (root / 'inputs-before.sha256').read_text().splitlines()]
assert inputs == [
    '0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d',
    '0e59dd07166433566edd18213d8a82bf6e039f1717dfb0f3f4284f2ae1bc514e',
    'a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33',
    '40c31757e3ffd1ce3f95f79ee9ba347ba97ba893aa66f6e69df4cc9e3b344c58',
    'ec51d7ef21ba8eaf3daaf9d3a2fe3a79473e25926e2c215976a4009b8626f196',
]
assert hashlib.sha256((root / 'workloads.sh').read_bytes()).hexdigest() == inputs[-1]
assert len(list(raw.glob('*.owner'))) == len(labels)
for label in labels:
    owner = (raw / f'{label}.owner').read_text()
    assert 'codex-1530-repeat:' in owner and f'title: PR 1530 compliant repeat {label}' in owner
    assert owner.count('taskset -c 2') == 1 and 'exec timeout 120s' in owner
    assert (raw / f'{label}.lock').exists() and (raw / f'{label}.stderr').exists()
object_rows = [line.split('  ', 1) for line in (root / 'object-hashes.txt').read_text().splitlines()]
object_labels = {Path(path).name.removesuffix('.o') for _, path in object_rows}
assert len(object_rows) == 48 and object_labels == {x for x in labels if x.startswith(('sq-', 'perf-'))}
assert len({digest for digest, _ in object_rows}) == 1
print('category\tbuild\tmetric\tn\tmedian\tmean\tmin\tmax\tunit')
for kind, builds, count in (('sq', names, 11), ('self', names[1:], 3)):
    for build in builds:
        for stage in ('check-input', 'check-program', 'total'):
            vals = []
            for r in range(count):
                lines = (raw / f'{kind}-{build}-{r}.stderr').read_text().splitlines()
                matches = [line.split('\t') for line in lines if line.startswith(f'time-stage\t{stage}\t')]
                assert len(matches) == 1
                vals.append(float(matches[0][2]))
            print(f'{kind}\t{build}\t{stage}\t{len(vals)}\t{median(vals):.3f}\t{mean(vals):.3f}\t{min(vals):.3f}\t{max(vals):.3f}\tms')
for build in names:
    for event in ('cycles:u', 'instructions:u', 'branches:u', 'branch-misses:u', 'task-clock'):
        vals = []
        for r in range(5):
            lines = (raw / f'perf-{build}-{r}.csv').read_text().splitlines()
            matches = [line.split(',') for line in lines if len(line.split(',')) > 4 and line.split(',')[2] == event]
            assert len(matches) == 1 and matches[0][4] == '100.00'
            vals.append(float(matches[0][0]))
        unit = 'ms' if event == 'task-clock' else 'count'
        print(f'perf\t{build}\t{event}\t{len(vals)}\t{median(vals):.3f}\t{mean(vals):.3f}\t{min(vals):.3f}\t{max(vals):.3f}\t{unit}')
print(f'objects\tall\tsha256\t{len(object_rows)}\t{object_rows[0][0]}\t-\t-\t-\t-')
for kind, builds, count in (('sq', names, 11), ('self', names[1:], 3)):
    for build in builds:
        hashes = set()
        for r in range(count):
            data = (raw / f'{kind}-{build}-{r}.stderr').read_bytes().splitlines(keepends=True)
            normalized = b''.join(line for line in data if not re.match(rb'^(time-stage|time-check|time-process|lowering-nodes)', line))
            hashes.add(hashlib.sha256(normalized).hexdigest())
        assert len(hashes) == 1
        print(f'diagnostics\t{build}\t{kind}\t{count}\t{hashes.pop()}\t-\t-\t-\tsha256')
