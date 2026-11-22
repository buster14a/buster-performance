from common import *
import csv,subprocess
out=D/'suites';out.mkdir(exist_ok=True);clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';origin=CC.parent.parent
checks=[('type-views',[CC,'test-types','--count','256','--seed','2850','--clang',clang])]+[(f'checker-{i}',[CC,'test-checker','--seed','2850','--part',f'{i}/8']) for i in range(1,9)]
with (out/'status.tsv').open('w',buffering=1) as fp:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['suite','exit'])
 for k,cmd in checks:
  with (out/(k+'.log')).open('wb') as log:r=subprocess.run(cmd,env=env|{'PATH':str(Path(clang).parent)+':'+env['PATH']},cwd=origin,stdout=log,stderr=subprocess.STDOUT)
  t.writerow([k,r.returncode]);print(k,r.returncode,flush=True)

subprocess.run(['python3',D/'mutation.py'],check=True)
