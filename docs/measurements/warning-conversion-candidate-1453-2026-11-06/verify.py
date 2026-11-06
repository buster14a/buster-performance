#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify the preserved samples and receipts, not build provenance."""
from datetime import datetime
import hashlib
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify.py EXTRACTED_DIRECTORY')
root = Path(sys.argv[1])
here = Path(__file__).resolve().parent
names = set()
for row in (here / 'RAW-SHA256SUMS').read_text().splitlines():
    digest, name = row.split('  ', 1)
    assert '/' not in name and name not in names
    names.add(name)
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == digest, name
assert {item.name for item in root.iterdir()} == names
samples = {
    'candidate10base': [(1390651902, 585236862), (1390651905, 581018783), (1390652468, 589484326)],
    'candidate10': [(1390550064, 614944508), (1390549551, 580489730), (1390549552, 581488417)],
}
binaries = {
    'candidate10base': '12d6ec12af9d640c9d0fe59dadf947d3d7308eaa4ea58dd6f1d9763583475e9b',
    'candidate10': 'ec807a8192add1760bb9e90c808305651383c8de92b86e8b1126c33b8a9f417b',
}
empty = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
diag = '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
times = {}
for version, pairs in samples.items():
    for number, pair in enumerate(pairs, 1):
        prefix = root / f'{version}-paired-{number}'
        events = {}
        for line in prefix.with_suffix('.perf').read_text().splitlines():
            if not line or line.startswith('#'):
                continue
            fields = line.split(',')
            assert len(fields) >= 5 and fields[2] not in events and fields[4] == '100.00'
            events[fields[2]] = int(fields[0])
        assert events == {'instructions:u': pair[0], 'cycles:u': pair[1]}
        assert prefix.with_suffix('.out').read_bytes() == b''
        assert hashlib.sha256(prefix.with_suffix('.err').read_bytes()).hexdigest() == diag
        lines = prefix.with_suffix('.receipt').read_text().splitlines()
        assert lines[0] == 'held=1' and lines.count('status=0') == 1
        status = lines.index('status=0')
        assert lines[status-1].split()[0] == binaries[version]
        assert lines[-2].split()[0] == empty and lines[-1].split()[0] == diag
        before, after = lines[1:status-1], lines[status+1:-2]
        assert before == after
        assert sum('codex-1453: bash -c' in line for line in before) == 1
        assert any(f'title: PR 1453 {version} conversion candidate sample {number}' in line for line in before)
        assert any(f' -- {version} {number} ' in line for line in before)
        times[(version, number)] = datetime.fromisoformat(before[0].split()[0])
order = (('candidate10base', 1), ('candidate10', 1), ('candidate10', 2),
         ('candidate10base', 2), ('candidate10base', 3), ('candidate10', 3))
assert [times[key] for key in order] == sorted(times.values())
print('Archived hashes, samples, output and recorded receipts verified; build provenance is not established.')
