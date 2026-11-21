#!/usr/bin/env python3
"""Compare optimized enum switch warnings and complete files using ordinary compiler binaries."""
import argparse
from hashlib import sha256
from itertools import product
from pathlib import Path
import subprocess
import tempfile

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('baseline',type=Path)
p.add_argument('candidate',type=Path)
p.add_argument('lua',type=Path,help='Lua 5.4.8 src directory containing lvm.c')
args=p.parse_args()
compilers=(args.baseline.resolve(),args.candidate.resolve())
fixture=Path(__file__).resolve().parent/'lua-switch-control.c'
policies=([],['-Wall','-Wextra'],['-Werror'],['-Wno-switch'],['-w'])
forms=('switch (e)', 'switch ((p->e))', 'switch (a[0])', 'switch (pick(e))')
ranges=('case A: case B: case C: return 1;', 'case A: return 4;',
        'case 9: case 11 ... 14: default: return 7;', 'case 5 ... 3: default: return 5;')
with tempfile.TemporaryDirectory() as temporary:
 folder=Path(temporary)
 def compare(src,flags):
  result=[]
  for exe in compilers:
   out=folder/'artifact.o'
   out.unlink(missing_ok=True)
   r=subprocess.run([str(exe),*flags,'-c',str(src),'-o',str(out)],capture_output=True)
   result.append((r.returncode,r.stdout,r.stderr,out.read_bytes() if out.exists() else None))
  assert result[0]==result[1],(src,flags)
  code,stdout,stderr,obj=result[0]
  print(src.name,' '.join(flags),code,sha256(stdout).hexdigest(),sha256(stderr).hexdigest(),sha256(obj).hexdigest() if obj is not None else 'absent',sep='\t')
  return obj is not None
 pairs=objects=0
 for flags in policies:
  for name in (fixture,args.lua.resolve()/'lvm.c'):
   objects+=compare(name,flags);pairs+=1
 for i,(form,rng) in enumerate(product(forms,ranges)):
  path=folder/f'check_{i}.c'
  path.write_text('enum E { A=0, AA=A, B=1, C=3 }; struct S { enum E e; }; enum E pick(enum E e){return e;}\n'
                  'int test(enum E e, const struct S *p, const enum E *a){'
                  +form+' {'+rng+'} return 0; }\n')
  for flags in policies:
   objects+=compare(path,flags);pairs+=1
 print(f'Matched {pairs} real compile pairs, including {objects} whole-object pairs.')
