#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Validate extracted retained exploratory receipts, not lock ownership or source builds."""
import hashlib
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify.py EXTRACTED_DIRECTORY')
root = Path(sys.argv[1])
here = Path(__file__).resolve().parent
expected_names = set()
for row in (here / 'RAW-SHA256SUMS').read_text().splitlines():
    digest, name = row.split('  ', 1)
    assert '/' not in name and name not in expected_names
    expected_names.add(name)
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == digest, name
assert {p.name for p in root.iterdir()} == expected_names
expected = [(1422915819, 595189020), (1422915814, 592794848), (1422915823, 591442122)]
for i, pair in enumerate(expected, 1):
    lines = (root / f'candidate8-{i}.perf').read_text().splitlines()
    events = {}
    for line in lines:
        if not line or line.startswith('#'):
            continue
        fields = line.split(',')
        assert len(fields) >= 5 and fields[2] not in events and fields[4] == '100.00'
        events[fields[2]] = int(fields[0])
    assert events == {'instructions:u': pair[0], 'cycles:u': pair[1]}
    assert (root / f'candidate8-{i}.out').read_bytes() == b''
for name in ('candidate8-1.err','candidate8-2.err','candidate8-3.err','debugbase-profile.err','debugfinal-profile.err'):
    assert hashlib.sha256((root / name).read_bytes()).hexdigest() == '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
for name in ('debugbase', 'debugfinal'):
    assert (root / f'{name}-profile.out').read_bytes() == b''
    report = (root / f'{name}-report.txt').read_text()
    assert "event 'instructions:u'" in report and 'Total Lost Samples: 0' in report
print('Retained file hashes, counter rows and output hashes verified; lock ownership and build provenance are not established by this verifier.')
