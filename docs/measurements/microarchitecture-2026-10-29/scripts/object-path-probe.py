#!/usr/bin/env python3
"""Compare objects from the same source named through two different paths."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

p = argparse.ArgumentParser()
p.add_argument('--compiler', required=True)
p.add_argument('--corpus', required=True)
p.add_argument('--out', required=True)
a = p.parse_args()
compiler, corpus, out = (Path(x).resolve() for x in (a.compiler, a.corpus, a.out))
out.mkdir(parents=True, exist_ok=True)
env = os.environ.copy()
env.update({'SOURCE_DATE_EPOCH': '1792454400', 'LC_ALL': 'C', 'CORES_TITLE': 'Inspect SQLite object identity'})
env.pop('CPATH', None)
env.pop('C_INCLUDE_PATH', None)
args = ['-c', '--predefines', str(corpus / 'provenance/gnu17-pinned-predefines.txt'),
        '--clang-features', '-march=znver5', '-std=gnu17', '-nostdinc',
        '-isystem', str(corpus / 'headers/usr/lib/clang/23/include'),
        '-isystem', str(corpus / 'headers/usr/local/include'),
        '-isystem', str(corpus / 'headers/usr/include'), '-I' + str(corpus / 'sqlite')]
result = {'description': 'Same compiler and source bytes, original source path versus a symlink path',
          'objects': {}, 'sections': {}}
with tempfile.TemporaryDirectory(prefix='buster-object-path-', dir=out) as tmp:
    tmp = Path(tmp)
    original = corpus / 'sqlite/sqlite3.c'
    alternate = tmp / 'sqlite3.c'
    alternate.symlink_to(original)
    for name, source in [('original', original), ('symlink', alternate)]:
        obj = tmp / (name + '.o')
        subprocess.run(['cores', '-n', '1', '--', str(compiler), *args, '-o', str(obj), str(source)],
                       env=env, check=True)
        symbols = subprocess.run(['readelf', '--wide', '--syms', str(obj)], check=True,
                                 text=True, capture_output=True).stdout.splitlines()
        result['objects'][name] = {'sha256': hashlib.sha256(obj.read_bytes()).hexdigest(),
                                   'file_symbol': next(x.strip() for x in symbols if ' FILE ' in x)}
    for section in ('.text', '.rodata', '.rodata.str1.1', '.data', '.data.rel.ro', '.eh_frame'):
        hashes = {}
        for name in ('original', 'symlink'):
            dest = tmp / (name + section + '.bin')
            subprocess.run(['objcopy', '--dump-section', section + '=' + str(dest),
                            str(tmp / (name + '.o')), '/dev/null'], check=True)
            hashes[name] = hashlib.sha256(dest.read_bytes()).hexdigest()
        result['sections'][section] = {'sha256': hashes, 'equal': hashes['original'] == hashes['symlink']}
(out / 'object-path-probe.json').write_text(json.dumps(result, indent=2) + '\n')
