#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify the preserved samples and receipts, not build provenance."""
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
        assert hashlib.sha256(prefix.with_suffix('.err').read_bytes()).hexdigest() == '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
        receipt = prefix.with_suffix('.receipt').read_text()
        assert 'held=1\n' in receipt and 'status=0\n' in receipt and 'codex-1453' in receipt
print('Archived hashes, samples, output and recorded receipts verified; build provenance is not established.')
