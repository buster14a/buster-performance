#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Independently check the retained repaired-main instruction-count receipts."""
from pathlib import Path
from statistics import median

root = Path(__file__).resolve().parent
raw = root / 'raw'
assert (raw / 'complete.txt').read_text().strip() == 'done'
assert (raw / 'pre-complete.txt').read_text().strip() == 'done'
assert (raw / 'syntax-complete.txt').read_text().strip() == 'done'
expected_executables = {
    'base': '5c07df7932e9579424c4827ef6e129317f8d8d29fe5a00750414faa149a5bc04',
    'integrated': '22435512a709d54edc50e7fca1b5cbd0c26b6c20b3bc5a114450a35ecf4a6e53',
}
assert len(list(raw.glob('*.bin.sha256'))) == 42
for f in raw.glob('*.bin.sha256'):
    variant = 'integrated' if 'integrated' in f.name else 'base'
    fields = f.read_text().split()
    assert len(fields) == 2 and fields[0] == expected_executables[variant] and fields[1].endswith('/1313-current-codex/compiler')
stdout = list(raw.glob('*.stdout'))
assert len(stdout) == 42 and all(f.read_bytes() == b'' for f in stdout)

def count(label):
    lines = (raw / f'{label}.perf').read_text().splitlines()
    matches = [line.split(',') for line in lines if ',instructions:u,' in line]
    assert len(matches) == 1 and matches[0][4] == '100.00'
    return int(matches[0][0])

def pairs(prefix, n):
    a = [count(f'{prefix}base-{i}') for i in range(1, n + 1)]
    b = [count(f'{prefix}integrated-{i}') for i in range(1, n + 1)]
    return a, b, [y-x for x, y in zip(a,b)]

base, integrated, compile_deltas = pairs('', 7)
_, _, preprocess_deltas = pairs('pre-', 4)
_, _, syntax_deltas = pairs('syntax-', 4)
assert compile_deltas == [17814,17815,17774,17818,17762,17765,17810]
assert preprocess_deltas == [-38,-40,-38,-40]
assert syntax_deltas == [17644,17639,17647,17664]
for prefix in ('', 'pre-', 'syntax-'):
    for variant in ('base', 'integrated'):
        first, second = (count(f'{prefix}aa-{variant}-{i}') for i in (1, 2))
        print(f'{prefix or "compile-"}aa-{variant}\t{first}\t{second}\t{second-first}')
for label, a, b, d in [('compile',base,integrated,compile_deltas), ('preprocess',*pairs('pre-',4)), ('syntax',*pairs('syntax-',4))]:
    print(f'{label}\tbase-median={median(a)}\tintegrated-median={median(b)}\tpaired-deltas={",".join(map(str,d))}\tpaired-median={median(d)}')
for name, expected_count in (('objects.sha256',18), ('pre-outputs.sha256',12)):
    hashes = [line.split()[0] for line in (raw/name).read_text().splitlines()]
    assert len(hashes) == expected_count and len(set(hashes)) == 1
    print(f'{name}\tsnapshots={len(hashes)}\tsha256={hashes[0]}')

def diagnostics(f):
    marker = b'exclusive.sh: waited for the shared 9700X lock; other holder details omitted\n'
    return f.read_bytes().replace(marker, b'')
compile_stderr = [diagnostics(raw / f'{prefix}{variant}-{i}.stderr')
                  for prefix, variants, indices in (('',('base','integrated'),range(1,8)), ('aa-',('base','integrated'),range(1,3)))
                  for variant in variants for i in indices]
assert len(compile_stderr) == 18 and len(set(compile_stderr)) == 1
print('compile-diagnostics\t18 normalized streams match; no per-sample freshness or byte-comparison receipt')
syntax_stderr = [diagnostics(raw / f'syntax-{prefix}{variant}-{i}.stderr')
                 for prefix, indices in (('',range(1,5)), ('aa-',range(1,3)))
                 for variant in ('base','integrated') for i in indices]
assert len(syntax_stderr) == 12 and len(set(syntax_stderr)) == 1
print('syntax-diagnostics\t12 normalized streams match')
