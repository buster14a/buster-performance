import concurrent.futures
import collections
import hashlib
import os
from pathlib import Path
import random
import re
import subprocess
import sys

compiler, generator, directory = (Path(a).resolve() for a in sys.argv[1:4])
work = directory.resolve()
work.mkdir(exist_ok=True, parents=True)
programs = int(sys.argv[4]) if len(sys.argv) > 4 else 15000
seeds = (61,62,63,64,65,66)

def compare(seed):
    os.environ['FUZZ_SLOPPY'] = '0.12' if seed in (65,66) else '0'
    source_code = generator.read_text().split('PRE = ',1)[1].split('key = re.compile',1)[0]
    ctx = dict(os=os, rng=random.Random(seed))
    exec('PRE = '+source_code, ctx)
    path = work/f'seed-{seed}.c'
    off = [str(compiler), '-fsyntax-only']
    if seed == 64:
        off.extend(['-Wall','-Wextra'])
    on = off + ['--node-window']
    digest = hashlib.sha256()
    ok=reject=different=signals=admitted_cases=admissions=0
    candidates = re.compile(r'return\s+[-+]?\s*(?:[\d\']|0x)')
    for i in range(programs):
        statement=ctx['statement']()
        rng=ctx['rng']
        if seed in (62,66):
            statement=' '.join([statement]+[ctx['statement']() for _ in range(rng.randrange(1,6))])
        pad='    local++;\n'*rng.randrange(0,70) if seed in (62,66) else ''
        prefix='#pragma STDC FENV_ACCESS ON\n' if seed == 63 else ''
        source=prefix+ctx['PRE']+pad+'    '+statement+ctx['POST']
        path.write_text(source)
        digest.update(source.encode())
        a=subprocess.run(off+[path],capture_output=True)
        b=subprocess.run(on+[path],capture_output=True)
        if (a.returncode,a.stdout,a.stderr) != (b.returncode,b.stdout,b.stderr):
            different+=1
            (work/f'{seed}-{i}-difference.c').write_text(source)
            (work/f'{seed}-{i}-before.log').write_bytes(a.stdout+a.stderr)
            (work/f'{seed}-{i}-after.log').write_bytes(b.stdout+b.stderr)
        signals+=a.returncode < 0 or b.returncode < 0
        ok+=a.returncode==0
        reject+=a.returncode!=0
        if a.returncode == 0 and candidates.search(statement):
            counter=subprocess.run(on+['--time-stages',path],capture_output=True)
            hits=re.search(rb'node-window[^\n]*?taken=(\d+)',counter.stderr)
            count=int(hits[1]) if hits else 0
            admitted_cases+=count>0
            admissions+=count
    return f'seed={seed} matched={programs-different}/{programs} successful={ok} rejected={reject} signals={signals} admitted_source_files={admitted_cases} expressions={admissions} source_sha256={digest.hexdigest()}'

def compare_probes(path):
    cases = []
    ctx={'OPTIONS':[], 'C':lambda name,source: cases.append((name,source))}
    exec(path.read_text(),ctx)
    stats=collections.Counter()
    for n,(name,source) in enumerate(cases):
        prefix=work/f'{path.stem}-{n}'
        file=prefix.with_suffix('.c')
        aobj=prefix.with_suffix('.off.o')
        bobj=prefix.with_suffix('.on.o')
        file.write_text(source)
        off=[str(compiler),'-c'] + ctx['OPTIONS']
        a=subprocess.run(off+[file,'-o',aobj],capture_output=True)
        b=subprocess.run(off+['--node-window',file,'-o',bobj],capture_output=True)
        same=(a.returncode,a.stdout,a.stderr)==(b.returncode,b.stdout,b.stderr)
        if a.returncode==0:
            stats['object']+=1
            same=same and aobj.exists() and bobj.exists() and aobj.read_bytes()==bobj.read_bytes()
        else:
            stats['rejected']+=1
        stats['signals']+=a.returncode<0 or b.returncode<0
        stats['same' if same else 'different']+=1
        if same:
            file.unlink()
            aobj.unlink(missing_ok=True)
            bobj.unlink(missing_ok=True)
        else:
            prefix.with_suffix('.off.log').write_bytes(a.stdout+a.stderr)
            prefix.with_suffix('.on.log').write_bytes(b.stdout+b.stderr)
    return path.stem, stats

if __name__ == '__main__':
    failed = False
    with concurrent.futures.ProcessPoolExecutor(max_workers=2) as executor:
        for result in executor.map(compare,seeds):
            print(result,flush=True)
            failed |= f'matched={programs}/{programs}' not in result or 'signals=0 ' not in result
    corpus=sorted(generator.resolve().parents[2].glob('*/probes/cases*.py'))
    sums=collections.Counter()
    with concurrent.futures.ProcessPoolExecutor(max_workers=2) as executor:
        for name,stats in executor.map(compare_probes,corpus):
            print('probe',name,dict(stats),flush=True)
            sums.update(stats)
    print('probes total',dict(sums),flush=True)
    sys.exit(int(failed or sums['different'] != 0 or sums['signals'] != 0))
