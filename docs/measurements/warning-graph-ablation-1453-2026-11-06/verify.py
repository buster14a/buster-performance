#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify archived bytes and recorded lock/counter receipts, not causal attribution."""
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
hashes = {'base': '7297fcb30ebb5dba02260b679cc099a203a795571d55b5cfbd169366ec35f007', 'head': 'c0715a9d80d3efdffdb6e6e294ff0a67afbc8268726e345ad93137482cdf79a8'}
samples = {
    ('base', 'on'): [(1362560063, 574710099), (1362560060, 573518012)],
    ('base', 'off'): [(1335568142, 556487016), (1335568143, 556896223)],
    ('head', 'on'): [(1389396137, 584732911), (1389396153, 580626064)],
    ('head', 'off'): [(1342333128, 559073308), (1342333135, 556426007)],
}
empty_hash = hashlib.sha256(b'').hexdigest()
error_hash = '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35'
times = {}
for (version, mode), pairs in samples.items():
    for number, pair in enumerate(pairs, 1):
        prefix = root / f'ablate-{version}-{mode}-{number}'
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
        assert any(f'title: PR 1453 {version} graph {mode} diagnostic sample {number}' in line for line in lines[1:-1])
        assert any(f' -- {version} {mode} {number} ' in line for line in lines[1:-1])
        times[(version, mode, number)] = datetime.fromisoformat(lines[1].split()[0])
        assert after_lines[-2].split()[0] == empty_hash and after_lines[-2].endswith(prefix.name + '.out')
        assert after_lines[-1].split()[0] == error_hash and after_lines[-1].endswith(prefix.name + '.err')
order = (('base','on',1), ('head','on',1), ('head','off',1), ('base','off',1), ('base','off',2), ('head','off',2), ('head','on',2), ('base','on',2))
assert [times[key] for key in order] == sorted(times.values())
for version, compiler in hashes.items():
    before, after = (root / f'ablate-{version}-build.receipt').read_text().split('\nstatus=0\n')
    lines, after_lines = before.splitlines(), after.splitlines()
    assert lines[0] == 'held=1' and lines[1:] == after_lines[:-1]
    assert 'codex-1453' in lines[1] and after_lines[-1].split()[0] == compiler
    assert any(f'title: PR 1453 ablate-{version} diagnostic ablation build' in line for line in lines[1:])
print('Archived hashes, counters, outputs and recorded receipts verified; build provenance and causal interpretation are not established.')
