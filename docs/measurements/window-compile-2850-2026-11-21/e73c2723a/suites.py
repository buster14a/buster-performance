from common import *
import csv,os,subprocess
subprocess.run(['python3',D/'mutate-operands.py'],check=True)
d=D/'suites';d.mkdir(exist_ok=True);clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
suites=[('program-vectors',[CC,'test-checker','--program-vectors','--seed','2850','--clang',clang])]
suites+=[(f'checker-{i}',[CC,'test-checker','--part',f'{i}/8','--seed','2850','--clang',clang]) for i in range(1,9)]
suites+=[(f'driver-{i}',[CC,'test-checker-driver','--executable',CC,'--part',f'{i}/8','--clang',clang]) for i in range(1,9)]
with (d/'status.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['suite','status'])
 for n,cmd in suites:
  with (d/(n+'.log')).open('wb') as log:r=subprocess.run(cmd,env=env|{'PATH':str(clang.parent)+':'+env['PATH']},cwd=CC.parent.parent,stdout=log,stderr=subprocess.STDOUT)
  t.writerow([n,r.returncode]);print(n,r.returncode,flush=True)
