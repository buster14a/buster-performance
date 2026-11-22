#!/usr/bin/env python3
# identity.py OUT NAME=EXE...: compile the frozen musl corpus's 1,336 units (#3126's compare-musl.py file choice and
# flags) and Lua 5.4.8's and SQLite's units at -O2, -O2 -g and -O0 -g, all by Tier 1 on one lane, with each compiler,
# 8 at a time; write OUT/NAME.tsv (set, source, status, sha256, size) for each compiler.
import concurrent.futures, hashlib, os, subprocess, sys
from pathlib import Path
out = Path(sys.argv[1]).resolve(); out.mkdir(parents=True, exist_ok=True)
compilers = [(a.split('=', 1)[0], str(Path(a.split('=', 1)[1]).resolve())) for a in sys.argv[2:]]
corpus = Path('/var/lib/buster-9700x/corpora/preprocessor-391e729af658')
musl = corpus / 'libc/musl'; gen = corpus / 'musl-generated/obj'
inputs = Path(os.environ['W']) / 'inputs'
musl_flags = ['--tier1', '-O2', '--lanes', '1', '-march=znver5', '-w', '-std=c99', '-nostdinc', '-ffreestanding', '-D_XOPEN_SOURCE=700']
for d in [musl / 'arch/x86_64', musl / 'arch/generic', gen / 'src/internal', musl / 'src/include', musl / 'src/internal', gen / 'include', musl / 'include']:
    musl_flags += ['-I', str(d)]
files = {}
for f in sorted(musl.glob('src/*/*.c')): files.setdefault(f.name, f)
for f in sorted(musl.glob('src/*/x86_64/*.c')): files.setdefault(f.name, f)
jobs = [('musl', str(f.relative_to(musl)), musl_flags + [str(f)]) for f in files.values()]
lua = ['-std=gnu99', '-DLUA_COMPAT_5_3', '-DLUA_USE_LINUX']
sqlite = ['-DSQLITE_THREADSAFE=0', '-DSQLITE_OMIT_LOAD_EXTENSION']
apps = [('lua/' + p.name, lua) for p in sorted((inputs / 'lua').glob('*.c'))] + [('sqlite3.c', sqlite)]
for mode, extra in [('O2', ['-O2']), ('O2-g', ['-O2', '-g']), ('O0-g', ['-O0', '-g'])]:
    for source, flags in apps:
        jobs.append(('app-' + mode, source, ['--tier1', *extra, '-march=znver5', '--lanes', '1', '-w', *flags, source]))
env = dict(os.environ, LC_ALL='C', SOURCE_DATE_EPOCH='1792454400')
scratch = Path('/dev/shm/claude3130-identity'); scratch.mkdir(parents=True, exist_ok=True)
def run(name, exe, index, job):
    kind, source, args = job
    obj = scratch / f'{name}-{index}.o'
    p = subprocess.run([exe, *args, '-c', '-o', str(obj)], cwd=inputs, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=300)
    data = obj.read_bytes() if p.returncode == 0 else p.stdout
    if obj.exists(): obj.unlink()
    return (kind, source, p.returncode, hashlib.sha256(data).hexdigest(), len(data))
for name, exe in compilers:
    with concurrent.futures.ThreadPoolExecutor(8) as pool:
        rows = list(pool.map(lambda ij: run(name, exe, ij[0], ij[1]), enumerate(jobs)))
    with open(out / f'{name}.tsv', 'w') as f:
        f.write('set\tsource\tstatus\tsha256\tbytes\n')
        for r in rows: f.write('\t'.join(map(str, r)) + '\n')
    print(name, exe, len(rows), 'units', sum(r[2] != 0 for r in rows), 'failed', flush=True)
