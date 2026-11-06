#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify retained counters and recorded receipts, not build provenance."""
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
hashes = {'currentbase': 'f786f812a5fd7fa73a5578fa5ce8f3ade3a9bc373e93d1e535b79e2eaf3ff3b8', 'currenthead': '2a0d56b9fe12dc897247102a5be960db60b18bad3f07f84fbc9df728b2734153', 'style': 'af29480fadd7731fa3aad10f2cb64ea56a26ee24125612ce95ea0e3ce1e7f295'}
samples = {
    ('currenthead', 'style-paired'): [(1390654958, 588284424), (1390654961, 584795780), (1390654953, 586713645)],
    ('style', 'style-paired'): [(1390654977, 583985634), (1390654972, 583772360), (1390654970, 584238436)],
    ('currentbase', 'style-base'): [(1363315020, 566634897), (1363315021, 566492394), (1363314998, 565266296)],
    ('style', 'style-base'): [(1390654070, 584749291), (1390654077, 586409232), (1390654078, 584340871)],
}
empty_hash = hashlib.sha256(b'').hexdigest()
error_hash = '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
for (version, label), pairs in samples.items():
    for number, pair in enumerate(pairs, 1):
        prefix = root / f'{version}-{label}-{number}'
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
        before, after = prefix.with_suffix('.receipt').read_text().split('\nstatus=0\n')
        lines, after_lines = before.splitlines(), after.splitlines()
        assert lines[0] == 'held=1' and lines[-1].split()[0] == hashes[version]
        assert lines[1:-1] == after_lines[:-2] and 'codex-1453' in lines[1]
        assert f'-- {version} {number} ' in before
        assert after_lines[-2].split()[0] == empty_hash and after_lines[-2].endswith(prefix.name + '.out')
        assert after_lines[-1].split()[0] == error_hash and after_lines[-1].endswith(prefix.name + '.err')
before, after = (root / 'style-build.receipt').read_text().split('\nstatus=0\n')
lines, after_lines = before.splitlines(), after.splitlines()
assert lines[0] == 'held=1' and lines[1:] == after_lines[:-1]
assert 'codex-1453' in lines[1] and after_lines[-1].split()[0] == hashes['style']
print('Archived hashes, counters, outputs and recorded receipts verified; build provenance is not established.')
