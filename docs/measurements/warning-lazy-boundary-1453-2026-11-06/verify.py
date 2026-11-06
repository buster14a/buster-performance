#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Verify archived bytes, counter rows, and receipt content; not provenance."""
from datetime import datetime
import hashlib
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: verify.py EXTRACTED_DIRECTORY')
root = Path(sys.argv[1])
here = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
names = set()
for row in (here / 'RAW-SHA256SUMS').read_text().splitlines():
    digest, name = row.split('  ', 1)
    assert '/' not in name and name not in names
    names.add(name)
    assert sha(root / name) == digest, name
assert {item.name for item in root.iterdir()} == names
compiler = {
    'ec5head': '2d80a3e01650bdc3218facdbb5870b96ad5929c74b9d91b5ff37e1563d838ab9',
    'candidate13': 'a562fe9adedfcc5147a8eee5235ea0de4b1e7192a47901b15f859282bc88624f',
}
fixture_hash = 'ccaae3bf73193177837b7f75623eddc228e01feb822027d0672d810929d3de46'
assert sha(root / 'warning-dense.c') == fixture_hash
empty = hashlib.sha256(b'').hexdigest()
errors = {'c13-paired': '8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35',
          'dense': '82d0e34518d4e92fd9411dca74eb5edbc58bfd728174099132047f1ca44fe929'}
# Populated with the twelve immutable recorded counter pairs after collection.
expected = {('c13-paired', 'ec5head', 1): (1390263595, 583792646), ('c13-paired', 'ec5head', 2): (1390263599, 581806477), ('c13-paired', 'ec5head', 3): (1390263592, 583725772), ('c13-paired', 'candidate13', 1): (1384332706, 580114439), ('c13-paired', 'candidate13', 2): (1384332720, 582544914), ('c13-paired', 'candidate13', 3): (1384332710, 580330365), ('dense', 'ec5head', 1): (52538351, 14528520), ('dense', 'ec5head', 2): (52538351, 14885660), ('dense', 'ec5head', 3): (52538356, 14376036), ('dense', 'candidate13', 1): (52564212, 14862639), ('dense', 'candidate13', 2): (52564209, 14751215), ('dense', 'candidate13', 3): (52564211, 15321276)}
times = {}
for kind in ('c13-paired', 'dense'):
    for version in ('ec5head', 'candidate13'):
        for number in (1, 2, 3):
            prefix = root / f'{version}-{kind}-{number}'
            events = {}
            for line in prefix.with_suffix('.perf').read_text().splitlines():
                if not line or line.startswith('#'):
                    continue
                fields = line.split(',')
                assert len(fields) >= 5 and fields[2] not in events and fields[4] == '100.00'
                events[fields[2]] = int(fields[0])
            assert events == dict(zip(('instructions:u', 'cycles:u'), expected[(kind, version, number)]))
            assert sha(prefix.with_suffix('.out')) == empty
            assert sha(prefix.with_suffix('.err')) == errors[kind]
            if kind == 'dense':
                assert prefix.with_suffix('.err').read_text().count('warning:') == 2048
            receipt = prefix.with_suffix('.receipt').read_text()
            before, after = receipt.split('\nstatus=0\n')
            lines = before.splitlines()
            after_lines = after.splitlines()
            assert lines[0] == 'held=1'
            hashes = 2 if kind == 'dense' else 1
            assert lines[-hashes].split()[0] == compiler[version]
            assert lines[-hashes].endswith('/compiler')
            if kind == 'dense':
                assert lines[-1].split()[0] == fixture_hash and lines[-1].endswith('/warning-dense.c')
            owner = lines[1:-hashes]
            assert owner == after_lines[:-2] and 'codex-1453' in owner[0]
            title = (f'PR 1453 {version} lazy publication boundary sample {number}' if kind == 'c13-paired'
                     else f'PR 1453 {version} warning-dense diagnostic sample {number}')
            assert f'  title: {title}' in owner
            assert any(f' -- {version} {number} ' in line for line in owner)
            assert '  link: https://github.com/buster14a/buster/pull/1453' in owner
            times[(kind, version, number)] = datetime.fromisoformat(owner[0].split()[0])
            assert after_lines[-2].split()[0] == empty and after_lines[-2].endswith(prefix.name + '.out')
            assert after_lines[-1].split()[0] == errors[kind] and after_lines[-1].endswith(prefix.name + '.err')
for kind in ('c13-paired', 'dense'):
    order = (('ec5head', 1), ('candidate13', 1), ('candidate13', 2), ('ec5head', 2), ('ec5head', 3), ('candidate13', 3))
    assert [times[(kind, *key)] for key in order] == sorted(times[(kind, *key)] for key in order)
print('Archived hashes, counters, diagnostics and receipt snapshots verified; build-time provenance is not established.')
