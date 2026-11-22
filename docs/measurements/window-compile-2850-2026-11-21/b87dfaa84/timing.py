from pathlib import Path
from collections import defaultdict
import csv,hashlib,os,statistics,subprocess,time
d=Path(__file__).resolve().parent; w=d.parent; src=w/'switch-inputs'; cc=d/'compiler-develop'
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
args=[os.fsdecode(v) for v in subprocess.check_output(['bash','-c','source ../switch-local-args.sh; eval "args=($sqlite_arguments)"; printf "%s\\0" "${args[@]}"'],cwd=src).split(b'\0')[:-1]]
expected=digest(w/'source-typed-study/sqlite.o');obj=d/'timed.o'
base={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_CONTROL_','BUSTER_CHAIN_'))}
arms=['ordinary','chain','single','single+chain','local','local+chain']
fields=['mode','round','position','arm','wall-ms','user-ms','sys-ms','rss-kib','faults','cycles','instructions','sha256']
allrows=[];outdir=d/'timed';outdir.mkdir(exist_ok=True)
with (d/'timing.tsv').open('w',buffering=1) as f:
 out=csv.DictWriter(f,delimiter='\t',fieldnames=fields);out.writeheader()
 for mode,n in [('wall',10),('pmu',6)]:
  for i in range(n):
   rot=i//2%len(arms);order=arms[rot:]+arms[:rot]
   if i%2:order=order[::-1]
   for pos,arm in enumerate(order):
    env=base.copy();fl=[]
    if 'chain' in arm:env['BUSTER_CONTROL_MEMBER_OPERANDS']='1'
    if 'single' in arm:fl.append('--node-window')
    if 'local' in arm:env.update(BUSTER_CONTROL_SOURCE_NATIVE='1',BUSTER_CONTROL_EARLY_NATIVE='1',BUSTER_CONTROL_EARLY_RELEASE='1')
    cmd=[cc,'--lanes','1',*fl,'-c',*args,'-o',obj];stem=outdir/f'{mode}-{i}-{arm}'
    if mode=='pmu':cmd=['perf','stat','-x',';','-o',stem.with_suffix('.pmu'),'-e','cycles:u,instructions:u','--',*cmd]
    with stem.with_suffix('.stderr').open('wb') as stderr:
     t=time.perf_counter_ns();proc=subprocess.Popen(cmd,env=env,cwd=src,stderr=stderr,stdout=stderr);_,status,u=os.wait4(proc.pid,0);proc.returncode=os.waitstatus_to_exitcode(status);elapsed=(time.perf_counter_ns()-t)/1e6
    assert proc.returncode==0,(mode,i,arm);h=digest(obj);assert h==expected,(mode,i,arm,h)
    counters={e[2]:int(e[0]) for line in stem.with_suffix('.pmu').read_text().splitlines() if len(e:=line.split(';'))>2} if mode=='pmu' else {}
    row=dict(zip(fields,[mode,i+1,pos+1,arm,round(elapsed,3),round(1000*u.ru_utime,3),round(1000*u.ru_stime,3),u.ru_maxrss,u.ru_minflt,counters.get('cycles:u',''),counters.get('instructions:u',''),h]))
    out.writerow(row);allrows.append(row)
with (d/'timing-summary.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['baseline','candidate','metric','baseline-median','candidate-median','paired-difference','paired-percent','n'])
 for a,b in zip(arms[::2],arms[1::2]):
  for mode,keys in [('wall',['wall-ms','user-ms','rss-kib','faults']),('pmu',['cycles','instructions'])]:
   for k in keys:
    pairs=[[r[k] for r in allrows if r['mode']==mode and r['arm']==q] for q in [a,b]]
    out.writerow([a,b,k,*map(statistics.median,pairs),statistics.median(y-x for x,y in zip(*pairs)),100*statistics.median(y/x-1 for x,y in zip(*pairs)),len(pairs[0])])
print((d/'timing-summary.tsv').read_text())
