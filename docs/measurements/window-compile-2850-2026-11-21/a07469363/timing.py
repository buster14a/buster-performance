from pathlib import Path
import csv,hashlib,os,subprocess,statistics,time
d=Path(__file__).resolve().parent;work=d.parent;b=d/'compiler-develop';source=work/'switch-inputs'
args=[os.fsdecode(v) for v in subprocess.check_output(['bash','-c','source ../switch-local-args.sh; eval "args=($sqlite_arguments)"; printf "%s\\0" "${args[@]}"'],cwd=source).split(b'\0')[:-1]]
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
expected=sha(work/'source-typed-study/sqlite.o');out=d/'timed.o'
base_env={k:v for k,v in os.environ.items() if not k.startswith('BUSTER_CONTROL_')}|{'BUSTER_CONTROL_SOURCE_NATIVE':'1','BUSTER_CONTROL_EARLY_NATIVE':'1','BUSTER_CONTROL_EARLY_RELEASE':'1'}
fields='mode round pos arm elapsed-ms user-ms system-ms maxrss-kib minor-faults cycles instructions object'.split()
rows=[]
with (d/'timing.tsv').open('w',buffering=1) as o:
 w=csv.DictWriter(o,delimiter='\t',fieldnames=fields);w.writeheader()
 for mode,n in [('wall',12),('pmu',8),('stages',4)]:
  for i in range(n):
   for pos,arm in enumerate(('baseline','cached') if i%2==0 else ('cached','baseline')):
    env=base_env|({'BUSTER_CONTROL_MEMBER_RULES':'1'} if arm=='cached' else {})
    cmd=[b,'--lanes','1',*(['--time-stages'] if mode=='stages' else []),'-c',*args,'-o',out]
    log=d/f'{mode}-{i}-{arm}.log';pmu=d/f'{mode}-{i}-{arm}.perf'
    if mode=='pmu':cmd=['perf','stat','-x',';','-o',pmu,'-e','cycles:u,instructions:u','--',*cmd]
    with log.open('wb') as f:
     t=time.perf_counter_ns();c=subprocess.Popen(cmd,cwd=source,env=env,stderr=f,stdout=f);pid,status,u=os.wait4(c.pid,0);c.returncode=os.waitstatus_to_exitcode(status);dt=(time.perf_counter_ns()-t)/1e6;assert c.returncode==0
    digest=sha(out);assert digest==expected
    data={v[2]:v[0] for line in pmu.read_text().splitlines() if len(v:=line.split(';'))>2} if mode=='pmu' else {}
    row=dict(zip(fields,[mode,i+1,pos+1,arm,round(dt,3),round(1000*u.ru_utime,3),round(1000*u.ru_stime,3),u.ru_maxrss,u.ru_minflt,data.get('cycles:u',''),data.get('instructions:u',''),digest]));w.writerow(row);rows.append(row)
with (d/'timing-summary.tsv').open('w') as o:
 w=csv.writer(o,delimiter='\t');w.writerow(['mode','key','baseline median','cached median','paired cached-baseline median'])
 for mode,keys in [('wall',['elapsed-ms','user-ms','maxrss-kib','minor-faults']),('pmu',['cycles','instructions'])]:
  rr=[r for r in rows if r['mode']==mode]
  for key in keys:
   baseline=[float(r[key]) for r in rr if r['arm']=='baseline'];cached=[float(r[key]) for r in rr if r['arm']=='cached']
   w.writerow([mode,key,statistics.median(baseline),statistics.median(cached),statistics.median([b-a for a,b in zip(baseline,cached)])])
print((d/'timing-summary.tsv').read_text())
