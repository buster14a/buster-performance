#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify retained profile bytes and the recorded receipt, not source provenance."""
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
assert (root / 'debug9-profile.out').read_bytes() == b''
assert hashlib.sha256((root / 'debug9-profile.err').read_bytes()).hexdigest() == '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
report = (root / 'debug9-report.txt').read_text()
assert "event 'instructions:u'" in report and 'Total Lost Samples: 0' in report
receipt = (root / 'debug9-profile.receipt').read_text()
assert 'held=1\n' in receipt and 'status=0\n' in receipt and 'codex-1453' in receipt
assert 'eeed8979503d4225dbf378a4f0579e7027d9db42ab5cf3e832a4dce868ca5ff7' in receipt
print('Archived hashes, output and recorded profile receipt verified; build provenance and profile interpretation are not established.')
