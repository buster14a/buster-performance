#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify preserved counters and recorded receipts, not build provenance."""
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
    'currenthead': ('2a0d56b9fe12dc897247102a5be960db60b18bad3f07f84fbc9df728b2734153', [(1390654614, 588086170), (1390654615, 582885431), (1390654617, 582542996)]),
    'candidate11': ('94e72730a0171b14ec16073f28700d25ca2848b9f06ac1fa073329096e2e187f', [(1389588148, 587060120), (1389588146, 587414109), (1389588147, 580768684)]),
}
empty_hash = hashlib.sha256(b'').hexdigest()
error_hash = '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
times = {}
for version, (compiler, pairs) in samples.items():
    for number, pair in enumerate(pairs, 1):
        prefix = root / f'{version}-c11-paired-{number}'
        events = {}
        for line in prefix.with_suffix('.perf').read_text().splitlines():
            if not line or line.startswith('#'):
                continue
            fields = line.split(',')
            assert len(fields) >= 5 and fields[2] not in events and fields[4] == '100.00'
            events[fields[2]] = int(fields[0])
        assert events == {'instructions:u': pair[0], 'cycles:u': pair[1]}
        assert prefix.with_suffix('.out').read_bytes() == b''
        assert hashlib.sha256(prefix.with_suffix('.err').read_bytes()).hexdigest() == error_hash
        receipt = prefix.with_suffix('.receipt').read_text()
        before, after = receipt.split('\nstatus=0\n')
        lines = before.splitlines()
        assert lines[0] == 'held=1' and lines[-1].split()[0] == compiler
        after_lines = after.splitlines()
        assert lines[1:-1] == after_lines[:-2] and 'codex-1453' in lines[1]
        assert any(f'title: PR 1453 {version} own conversion reach sample {number}' in line for line in lines[1:-1])
        assert any(f' -- {version} {number} ' in line for line in lines[1:-1])
        times[(version, number)] = datetime.fromisoformat(lines[1].split()[0])
        assert after_lines[-2].split()[0] == empty_hash and after_lines[-2].endswith(prefix.name + '.out')
        assert after_lines[-1].split()[0] == error_hash and after_lines[-1].endswith(prefix.name + '.err')
order = (('currenthead', 1), ('candidate11', 1), ('candidate11', 2), ('currenthead', 2), ('currenthead', 3), ('candidate11', 3))
assert [times[key] for key in order] == sorted(times.values())
print('Archived hashes, counters, outputs and recorded receipts verified; build provenance is not established.')
