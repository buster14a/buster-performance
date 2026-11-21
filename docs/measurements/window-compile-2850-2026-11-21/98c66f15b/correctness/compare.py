#!/usr/bin/env python3
"""Compare ordinary compiler artifacts, statuses and diagnostics across unused warning policies."""
from argparse import ArgumentParser
from collections import Counter
from hashlib import sha256
from itertools import product
from pathlib import Path
import subprocess
import tempfile

parser = ArgumentParser(description=__doc__)
parser.add_argument('baseline', type=Path)
parser.add_argument('candidate', type=Path)
parser.add_argument('sqlite', type=Path, help='Directory containing the frozen sqlite3.c and sqlite3.h')
args = parser.parse_args()
compilers = [args.baseline.resolve(), args.candidate.resolve()]
sqlite = args.sqlite.resolve()
fixtures = Path(__file__).resolve().parent
policies = [
    [], ['-Werror'], ['-Wall'], ['-Wall', '-Wextra'], ['-Wall', '-Wextra', '-Werror'],
    ['-Weverything'], ['-w'], ['-Wno-unused'], ['-Werror=unused-variable'],
    ['-Wunused-local-typedef'], ['-Wunused-const-variable'], ['-Wunused-but-set-variable'],
    ['-Wunused-function'], ['-Wunused-parameter'], ['-w', '-Werror=unused-variable'],
    ['-Wunused-label'],
]

def compare(name, arguments, out, ledger):
    results = []
    for compiler in compilers:
        out.unlink(missing_ok=True)
        run = subprocess.run([str(compiler), *arguments, '-o', str(out)], capture_output=True)
        results.append((run.returncode, run.stdout, run.stderr, out.read_bytes() if out.exists() else None))
    if results[0] != results[1]:
        raise ValueError(f'Compiler mismatch in {name} {arguments}')
    status, stdout, stderr, obj = results[0]
    ledger['pairs'] += 1
    ledger['present'] += obj is not None
    print(name, ' '.join(arguments[:-1]), status, sha256(stdout).hexdigest(),
          sha256(stderr).hexdigest(), sha256(obj).hexdigest() if obj is not None else 'absent', sep='\t')

with tempfile.TemporaryDirectory() as directory:
    out = Path(directory) / 'result.o'
    counts = Counter()
    for name in ['unused-case.c', 'pragma-case.c', 'negative.c']:
        for policy, mode in product(policies, [['-c'], ['-c', '--deferred-bodies', '--lanes', '3'],
                                               ['-fsyntax-only'], ['-c', '--scalar']]):
            compare(name, [*mode, *policy, str(fixtures / name)], out, counts)
    for policy in policies[:8]:
        compare('sqlite3.c', ['-c', *policy, '-I' + str(sqlite), '-DSQLITE_OMIT_LOAD_EXTENSION',
                               '-DSQLITE_THREADSAFE=0', '-DSQLITE_ENABLE_MEMSYS5', '-DSQLITE_ENABLE_RTREE',
                               str(sqlite / 'sqlite3.c')], out, counts)
    print(f"Matched {counts['pairs']} real compile pairs, including {counts['present']} whole-object pairs.")
