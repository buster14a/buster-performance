"""Compare two Buster compilers and link valid fixtures with the pinned Clang."""
import argparse
import csv
import hashlib
from pathlib import Path
import subprocess
import tempfile

p = argparse.ArgumentParser()
p.add_argument('baseline', type=Path)
p.add_argument('candidate', type=Path)
p.add_argument('clang', type=Path)
p.add_argument('sources', type=Path)
p.add_argument('observations', type=Path)
args = p.parse_args()
flags = {'syntax': ['-fsyntax-only', '-Wall', '-Wextra'],
         'everything': ['-fsyntax-only', '-Weverything', '-Wno-c++-compat'],
         'object': ['-c'], 'debug': ['-g', '-c'], 'tier1': ['--tier1', '-c']}
def run(argv):
    proc = subprocess.run(argv, capture_output=True, timeout=90)
    return proc.returncode, proc.stdout, proc.stderr
with tempfile.TemporaryDirectory() as temporary, args.observations.open() as table:
    obj = Path(temporary) / 'unit.o'
    for row in csv.DictReader(table, delimiter='\t'):
        case, mode = row['case'], row['mode']
        source = args.sources / (case+'.c')
        pair = []
        for cc in [args.baseline, args.candidate]:
            obj.unlink(missing_ok=True)
            result = run([cc.resolve(), '-std=gnu23', *flags[mode], source, '-o', obj])
            pair.append((*result, obj.read_bytes() if obj.exists() else b''))
        assert pair[0] == pair[1] and pair[0][0] == int(row['status']), (case, mode)
        if row['runtime'] != '-':
            buster = Path(temporary) / 'buster'
            reference = Path(temporary) / 'clang'
            assert run([args.clang, '-no-pie', obj, '-o', buster])[0] == 0
            assert run([args.clang, '-std=gnu23', '-O0', source, '-o', reference])[0] == 0
            actual = run([buster])
            assert actual == run([reference]) and hashlib.sha256(actual[1]).hexdigest() == row['runtime'], (case, mode)
