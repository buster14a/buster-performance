from pathlib import Path
import csv,gzip,json,os,re,resource,statistics,subprocess,sys,time
st=Path(__file__).resolve().parent;w=st.parent;doc=w/'perf/docs/measurements/window-compile-2850-2026-11-21/4bd73ecaf';sys.path.insert(0,str(doc));from reproduce import frozen_args
cc=w/'ordinary-store-transfers/build/compiler';args=frozen_args(w/'switch-inputs/sqlite/sqlite3.c',w/'pregraph-warning-study/compiler-source')
out=st/'stage';out.mkdir(exist_ok=True);cpu=min(os.sched_getaffinity(0));os.sched_setaffinity(0,{cpu})
clean={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_CHECK_BODY_','BUSTER_CHECK_SOURCE_DECLARATIONS','BUSTER_BODY_','BUSTER_CHECK_ORDINARY_ACTION'))}
shared={}
with (out/'samples.tsv').open('w',buffering=1) as file:
 t=csv.writer(file,delimiter='\t',lineterminator='\n');t.writerow(('input','scope','series','round','position','mode','ns','user-ns','system-ns','minor','major','peak-kib','instructions-u','cycles-u'))
 for name,flags in args.items():
  for sc in ('object',):
   env=clean|shared|({'BUSTER_CHECK_SOURCE_DECLARATIONS':'1'} if sc=='declarations' else {})
   for series in ('wall','pmu'):
    n=5 if series=='wall' else 3 if series=='pmu' else 1
    for r in range(1,n+1):
     order=('baseline','candidate','candidate','baseline') if r%2 else ('candidate','baseline','baseline','candidate')
     for k,mode in enumerate(order):
      active=env|({'BUSTER_CHECK_ORDINARY_ACTION_ROWS':'1'} if mode=='candidate' else {})|({'BUSTER_CHECK_BODY_ACTION_AUDIT':'1'} if series=='coverage' else {})
      stem=out/f'{name}.{sc}.{series}.{r}.{k}.{mode}';cmd=[cc,'--lanes','1','-c',*flags,'-o',out/'compile.o']
      if series=='pmu':cmd=['perf','stat','-x,','--no-big-num','-e','instructions:u,cycles:u','-o',str(stem)+'.perf','--',*cmd]
      with open(str(stem)+'.stderr','wb') as err:
       start=time.monotonic_ns();proc=subprocess.Popen(cmd,env=active,stderr=err,stdout=subprocess.DEVNULL);_,stat,u=os.wait4(proc.pid,0);end=time.monotonic_ns();proc.returncode=os.waitstatus_to_exitcode(stat);assert proc.returncode==0,(name,sc,series,r,k)
      stats=({x[2]:x[0] for x in csv.reader(Path(str(stem)+'.perf').read_text().splitlines()) if len(x)>2} if series=='pmu' else {})
      t.writerow([name,sc,series,r,k,mode,end-start,round(u.ru_utime*1e9),round(u.ru_stime*1e9),u.ru_minflt,u.ru_majflt,u.ru_maxrss,stats.get('instructions:u',''),stats.get('cycles:u','')])
