#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Check preserved candidate9 measurements and owner records, not source provenance."""
from datetime import datetime
import hashlib
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify.py EXTRACTED_DIRECTORY')
root = Path(sys.argv[1]); here = Path(__file__).resolve().parent
names = set()
for line in (here / 'RAW-SHA256SUMS').read_text().splitlines():
    digest, name = line.split('  ', 1)
    assert '/' not in name and name not in names
    names.add(name)
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == digest, name
assert {p.name for p in root.iterdir()} == names
expected = {
    'base-final-1': (1363327839, 564468981), 'candidate9-final-1': (1390651884, 585249584),
    'base-final-2': (1363327859, 563569244), 'candidate9-final-2': (1390651872, 583167441),
    'base-final-3': (1363327824, 566571126), 'candidate9-final-3': (1390651878, 583120686),
    'candidate9-1': (1390652265, 606467462), 'candidate9-2': (1390651764, 584433810),
    'candidate9-3': (1390651751, 585400197),
}
empty = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
diag = '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
binaries = {'base': '5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04',
            'candidate9': '2a37f20b11904ffec4caac79267606429ec919f1ba679e74db0ff7141c24901e'}
times = {}
for name, pair in expected.items():
    events = {}
    for line in (root / f'{name}.perf').read_text().splitlines():
        if not line or line.startswith('#'): continue
        fields = line.split(',')
        assert len(fields) >= 5 and fields[2] not in events and fields[4] == '100.00'
        events[fields[2]] = int(fields[0])
    assert events == {'instructions:u': pair[0], 'cycles:u': pair[1]}
    assert hashlib.sha256((root / f'{name}.out').read_bytes()).hexdigest() == empty
    assert hashlib.sha256((root / f'{name}.err').read_bytes()).hexdigest() == diag
    if '-final-' not in name: continue
    variant, _, round_no = name.split('-')
    lines = (root / f'{name}.receipt').read_text().splitlines()
    assert lines[0] == 'held=1' and lines.count('status=0') == 1
    status = lines.index('status=0')
    assert lines[status-1].split()[0] == binaries[variant]
    assert lines[-2].split()[0] == empty and lines[-1].split()[0] == diag
    before, after = lines[1:status-1], lines[status+1:-2]
    assert before == after and any(f'title: PR 1453 {variant} final paired sample {round_no}' in line for line in before)
    assert sum('codex-1453: bash -c' in line for line in before) == 1
    times[name] = datetime.fromisoformat(before[0].split()[0])
order = ('base-final-1', 'candidate9-final-1', 'candidate9-final-2', 'base-final-2', 'base-final-3', 'candidate9-final-3')
assert [times[n] for n in order] == sorted(times.values())
control_counts = {
    'base-no-warnings-c9-1': (1179253463, 470777678), 'base-no-warnings-c9-2': (1179253454, 470542213),
    'candidate9-no-warnings-c9-1': (1183479668, 475253884), 'candidate9-no-warnings-c9-2': (1183479669, 473105870),
    'base-no-return-c9-1': (1354158680, 560083621), 'base-no-return-c9-2': (1354158709, 564810632),
    'candidate9-no-return-c9-1': (1387373949, 583598486), 'candidate9-no-return-c9-2': (1387373952, 582311118),
}
for name, pair in control_counts.items():
    variant = name.split('-', 1)[0]
    policy = 'no-warnings' if '-no-warnings-' in name else 'no-return'
    round_no = name.rsplit('-', 1)[1]
    events = {}
    for line in (root / f'{name}.perf').read_text().splitlines():
        if not line or line.startswith('#'): continue
        fields = line.split(',')
        assert len(fields) >= 5 and fields[2] not in events and fields[4] == '100.00'
        events[fields[2]] = int(fields[0])
    assert events == {'instructions:u': pair[0], 'cycles:u': pair[1]}
    assert hashlib.sha256((root / f'{name}.out').read_bytes()).hexdigest() == empty
    expected_err = empty if policy == 'no-warnings' else diag
    assert hashlib.sha256((root / f'{name}.err').read_bytes()).hexdigest() == expected_err
    lines = (root / f'{name}.receipt').read_text().splitlines()
    assert lines[0] == 'held=1' and lines.count('status=0') == 1
    status = lines.index('status=0')
    assert lines[status-1].split()[0] == binaries[variant]
    assert lines[-2].split()[0] == empty and lines[-1].split()[0] == expected_err
    before, after = lines[1:status-1], lines[status+1:-2]
    assert before == after and any(f'title: PR 1453 {variant} {policy} sample {round_no}' in line for line in before)
    assert sum('codex-1453: bash -c' in line for line in before) == 1
    option = '-w' if policy == 'no-warnings' else '-Wno-return-type'
    assert any(f' -- {variant} {policy} {round_no} {option} ' in line for line in before)
    times[name] = datetime.fromisoformat(before[0].split()[0])
for policy in ('no-warnings', 'no-return'):
    order = (f'base-{policy}-c9-1', f'candidate9-{policy}-c9-1', f'candidate9-{policy}-c9-2', f'base-{policy}-c9-2')
    assert [times[n] for n in order] == sorted(times[n] for n in order)
print('All 17 counter/output records and 14 held/status/owner/hash receipts verified; build-time source provenance is not established.')
