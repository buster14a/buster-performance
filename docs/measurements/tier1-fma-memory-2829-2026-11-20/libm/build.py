import argparse
import hashlib
import os
import subprocess
from pathlib import Path
p=argparse.ArgumentParser()
p.add_argument('corpus',type=Path)
p.add_argument('parent',type=Path)
p.add_argument('candidate',type=Path)
p.add_argument('clang',type=Path)
args=p.parse_args()
root=Path(__file__).resolve().parent
musl=args.corpus.resolve()/'libc/musl'
overlay=args.corpus.resolve()/'musl-generated/obj'
inc=[musl/'arch/x86_64',musl/'arch/generic',overlay/'src/internal',musl/'src/include',musl/'src/internal',overlay/'include',musl/'include']
flags=['-O2','-march=znver5','-w','-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700']
flags += [x for i in inc for x in ('-I',str(i))]
env=dict(os.environ,SOURCE_DATE_EPOCH='1792454400')
with (root/'inputs.tsv').open('w') as manifest:
    manifest.write('source\tsha256\n')
    sources=sorted((musl/'src/math').glob('*.c'))+sorted((musl/'src/complex').glob('*.c'))
    for s in sources:
        manifest.write(f'{s.relative_to(musl)}\t{hashlib.sha256(s.read_bytes()).hexdigest()}\n')
for name,compiler in [('parent',args.parent.resolve()),('candidate',args.candidate.resolve()),('clang',args.clang.resolve())]:
    directory=root/name
    directory.mkdir(exist_ok=True)
    prefix=[] if name=='clang' else ['--tier1','--lanes','1']
    objects=[]
    with (directory/'diagnostics.txt').open('wb') as log:
        for src in sources:
            obj=directory/(src.stem+'.o')
            subprocess.run([compiler,*prefix,*flags,'-c',src,'-o',obj],check=True,stdout=log,stderr=log,env=env)
            objects.append(obj)
    subprocess.run(['ar','rcsD',directory/'libmath.a',*objects],check=True)
    print(name,len(objects),flush=True)
