from common import *
import csv,hashlib,resource,subprocess,time
out=D/'stage';out.mkdir(exist_ok=True);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
objects={n:hashlib.sha256((W/'source-typed-study'/(n+'.o')).read_bytes()).hexdigest() for n in args}
with (out/'samples.tsv').open('w',buffering=1) as file:
 t=csv.writer(file,delimiter='\t',lineterminator='\n');t.writerow(('input','scope','series','round','position','mode','ns','user-ns','system-ns','minor','major','peak-kib','instructions-u','cycles-u','ELF'))
 for name,flags in args.items():
  for sc in ('native','local-stage'):
   activebase=env | (native if sc=='native' else (local|{'BUSTER_BODY_DISCARD_RESULT':'1'}))
   for series in ('wall','pmu'):
    n=5 if series=='wall' else 3 if series=='pmu' else 1
    for r in range(1,n+1):
     order=('baseline','candidate','candidate','baseline') if r%2 else ('candidate','baseline','baseline','candidate')
     for k,mode in enumerate(order):
      active=activebase|(producer if mode=='candidate' else {})
      stem=out/f'{name}.{sc}.{series}.{r}.{k}.{mode}';cmd=[CC,'--lanes','1','-c',*flags,'-o',out/'compile.o']
      if series=='pmu':cmd=['perf','stat','-x,','--no-big-num','-e','instructions:u,cycles:u','-o',str(stem)+'.perf','--',*cmd]
      with open(str(stem)+'.stderr','wb') as err:
       start=time.monotonic_ns();proc=subprocess.Popen(cmd,env=active,cwd=ROOT,stderr=err,stdout=subprocess.DEVNULL);_,stat,u=os.wait4(proc.pid,0);end=time.monotonic_ns();proc.returncode=os.waitstatus_to_exitcode(stat);assert proc.returncode==0,(name,sc,series,r,k)
      stats=({x[2]:x[0] for x in csv.reader(Path(str(stem)+'.perf').read_text().splitlines()) if len(x)>2} if series=='pmu' else {})
      objhash='-'
      if sc=='native':
       obj=out/'compile.o';objhash=hashlib.sha256(obj.read_bytes()).hexdigest();assert objhash==objects[name],(name,sc,objhash,objects[name])
      t.writerow([name,sc,series,r,k,mode,end-start,round(u.ru_utime*1e9),round(u.ru_stime*1e9),u.ru_minflt,u.ru_majflt,u.ru_maxrss,stats.get('instructions:u',''),stats.get('cycles:u',''),objhash])

subprocess.run(['python3', D/'process.py'],check=True)
subprocess.run(['python3', D/'runtime.py'],check=True)

subprocess.run(['python3', D/'profile.py'],check=True)

subprocess.run(['bash', D/'per-file.sh'],check=True)

subprocess.run(['python3',D/'reproduce.py','--base',PRIOR,'--candidate',CC,'--sqlite',args['sqlite'][-1],'--buster-source',src,'--predefines',str(ROOT)+'/../proof-predefines.h','--cases',D/'oracle/cases','--out',D/'replay'],check=True)

checks=D/'checker';checks.mkdir(exist_ok=True)
with (checks/'status.tsv').open('w',buffering=1) as table:
 table.write('shard\texit\n')
 for i in range(1,9):
  with (checks/f'checker-{i}.log').open('wb') as f:
   e=env|{'PATH':'/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:'+os.environ['PATH']}
   r=subprocess.run([CC,'test-checker','--seed','2850','--part',f'{i}/8'],cwd=CC.parent.parent,stdout=f,stderr=subprocess.STDOUT,env=e)
  table.write(f'{i}\t{r.returncode}\n');assert r.returncode==0,i
