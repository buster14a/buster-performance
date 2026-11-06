#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Validate and summarize the retained, separately locked repaired-main measurement."""
from pathlib import Path
from statistics import mean, median
import hashlib
import re
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: summarize.py EXTRACTED_DATA_DIRECTORY')
root = Path(sys.argv[1])
raw = root / 'raw'
names = ('base', 'integrated')
labels = []
for r in range(11):
    labels.extend(f'sq-{names[(j+r)%2]}-{r}' for j in range(2))
for r in range(5):
    labels.extend(f'perf-{names[(j+r)%2]}-{r}' for j in range(2))
for r in range(3):
    labels.extend(f'self-{names[(j+r)%2]}-{r}' for j in range(2))
rows = [line.split('\t') for line in (root / 'status.tsv').read_text().splitlines()]
assert len(rows) == 38 and [r[0] for r in rows] == labels and all(r[1:] == ['0'] for r in rows)
assert (root / 'complete.txt').read_text().strip() == 'done'
assert (root / 'identities.txt').read_text().splitlines()[:3] == ['base=ee089fe78414054d04e5350c48a783e9e2f05af8', 'head=e94fd0d2bcada50d237ac14206a32cf2b68dc1ff', 'integration_tree=507b80b88c6556df8c653302ab891684dba739d9']
assert (root / 'inputs-before.sha256').read_bytes() == (root / 'inputs-after.sha256').read_bytes()
expected_binaries = (
    '5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04',
    'e2d965254d9e7ad4e05e6e04f56606c5646c0cefea92bf2d7660af9b8bc737cd',
)
assert tuple(line.split()[0] for line in (root / 'binaries.sha256').read_text().splitlines()) == expected_binaries
after = (root / 'binaries-after.txt').read_text().splitlines()
assert len(after) == 2 and all(line.endswith(': OK') for line in after)
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
    assert 'codex-1530-current:' in owner and f'title: PR 1530 repaired-base {label}' in owner
    assert owner.count('taskset -c 2') == 1 and 'exec timeout 120s' in owner
    assert (raw / f'{label}.lock').exists() and (raw / f'{label}.stderr').exists()
    assert (raw / f'{label}.stdout').read_bytes() == b''
object_rows = [line.split('  ', 1) for line in (root / 'object-hashes.txt').read_text().splitlines()]
object_labels = {Path(path).name.removesuffix('.o') for _, path in object_rows}
assert len(object_rows) == 32 and object_labels == {x for x in labels if x.startswith(('sq-', 'perf-'))}
assert {digest for digest, _ in object_rows} == {'61eb96dd33188557f23a27c24dcf347a8b704d8f8ec15c3656c4e447de3856f2'}
print('category\tbuild\tmetric\tn\tmedian\tmean\tmin\tmax\tunit')
for kind, builds, count in (('sq', names, 11), ('self', names, 3)):
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
for kind, builds, count in (('sq', names, 11), ('self', names, 3)):
    for build in builds:
        hashes = set()
        for r in range(count):
            data = (raw / f'{kind}-{build}-{r}.stderr').read_bytes().splitlines(keepends=True)
            normalized = b''.join(line for line in data if not re.match(rb'^(time-stage|time-check|time-process|lowering-nodes)', line))
            hashes.add(hashlib.sha256(normalized).hexdigest())
        assert hashes == {'b7b0875a20c10894f5028d25d87482c830c55052fdaf341759e7eb7c492507c5' if kind == 'sq' else '936fd7fa3a60313ce1c85ba753c6f0b2daafda845a0dd159ae0bc85a6f9f2b0b'}
        print(f'diagnostics\t{build}\t{kind}\t{count}\t{hashes.pop()}\t-\t-\t-\tsha256')
