from pathlib import Path
import csv,subprocess,hashlib,os,itertools
p=Path(__file__).resolve().parent;w=p.parent
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
targets={'generic':['-march=x86-64'],'v3':['-march=x86-64-v3'],'znver5':['-march=znver5'],'v4':['-march=x86-64-v4'],'v4-no-f':['-march=x86-64-v4','-mno-avx512f']}
def run(*a,**kw):return subprocess.run(list(map(str,a)),**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
run(cc,'-O2','-march=x86-64-v3','-ffp-contract=off','-c',p/'oracle.c','-o',p/'oracle.o',check=True)
ledger=[]
for name,opts in targets.items():
 for sched in ['default','post']:
  for label,compiler in [('parent',w/'eighteen-control/build/compiler'),('head',w/'unsigned64/build/compiler'),('clang',cc)]:
   if label=='clang' and sched!='default':continue
   path=p/'checks'/(name+'-'+sched+'-'+label);path.parent.mkdir(exist_ok=True);obj=path.with_suffix('.o')
   flags=['-O2',*opts]+(['--tier1','--lanes','1']+(['--tier1-schedule=post'] if sched=='post' else []) if label!='clang' else ['-frounding-math'])
   r=run(compiler,*flags,'-c',p/'leaves.c','-o',obj,capture_output=True,text=True)
   if r.returncode: ledger.append([name,sched,label,'build-failed','','','',r.stderr[:120]]);continue
   run(cc,'-no-pie',p/'oracle.o',obj,'-o',path,check=True);ass=run('objdump','-d','-Mintel',obj,capture_output=True,text=True,check=True).stdout;path.with_suffix('.asm').write_text(ass)
   r=run(path,capture_output=True,text=True);path.with_suffix('.log').write_text(r.stdout+r.stderr)
   ledger.append([name,sched,label,r.returncode,ass.count('vcvtusi2s'),sha(obj),sha(path),r.stdout.strip()]);print(ledger[-1],flush=True)
with (p/'results.tsv').open('w') as h:
 t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['target','schedule','compiler','oracle_exit','evex_sites','object_sha256','exe_sha256','oracle']);t.writerows(ledger)
