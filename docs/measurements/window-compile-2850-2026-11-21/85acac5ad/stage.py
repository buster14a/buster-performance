from common import *
import csv,gzip,hashlib,statistics,subprocess,sys,time
folder=D/'stage';folder.mkdir(exist_ok=True);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))});sources={'ordinary':{},'native':native,'functions':local|{'BUSTER_BODY_DISCARD_RESULT':'1'}}
modes=['prior-ordinary','new-ordinary','prior-native','new-native'];variants={m:(PRIOR if m.startswith('prior') else CC,sources[m.split('-')[1]]) for m in modes};order=[[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]]
samples=[]
with (folder/'samples.tsv').open('w',buffering=1) as fp,(folder/'paired.tsv').open('w',buffering=1) as pf:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['input','scope','series','round','position','mode','ns','instructions','cycles','ELF'])
 pt=csv.writer(pf,delimiter='\t',lineterminator='\n');pt.writerow(['input','scope','series','metric','parent-median','candidate-median','median-delta','minimum-delta','maximum-delta','faster','rounds'])
 for name,flags in args.items():
  expected=hashlib.sha256((W/'source-typed-study'/(name+'.o')).read_bytes()).hexdigest();obj=folder/'unit.o'
  for cohort in ('ordinary',):
   active=modes if cohort=='production' else ['prior-ordinary','new-ordinary']
   if cohort=='functions':variants.update({m:(PRIOR if m.startswith('prior') else CC,sources['functions']) for m in active})
   for series,reps in [('wall',8 if cohort=='production' else 5),('pmu',4 if cohort=='production' else 3)]:
    allr=[]
    for r in range(reps):
     positions=order[r%4] if cohort=='production' else ([0,1,1,0] if r%2==0 else [1,0,0,1]);positions=positions if r<4 or cohort=='functions' else positions[::-1]
     for k,idx in enumerate(positions):
      m=active[idx];cc,e=variants[m];scope=m.split('-')[1];stem=folder/f'{name}.{scope}.{series}.{r}.{k}.{m}';cmd=[cc,'--lanes','1','-c',*flags,'-o',obj];pm=Path(str(stem)+'.perf')
      if series=='pmu':cmd=['perf','stat','-x,','--no-big-num','-e','instructions:u,cycles:u','-o',pm,'--',*cmd]
      start=time.monotonic_ns();p=subprocess.run(cmd,env=env|e,cwd=ROOT,capture_output=True);end=time.monotonic_ns();Path(str(stem)+'.stderr').write_bytes(p.stderr);assert p.returncode==0,(name,m,p.stderr[:200])
      h='-'
      if cohort=='ordinary':h=hashlib.sha256(obj.read_bytes()).hexdigest();assert h==expected,(name,m,h)
      stats=({z[2]:int(z[0]) for z in csv.reader(pm.read_text().splitlines()) if len(z)>2} if series=='pmu' else {})
      rr=[name,scope,series,r,k,m,end-start,stats.get('instructions:u',''),stats.get('cycles:u',''),h];t.writerow(rr);allr.append(rr)
    for scope in (('native','ordinary') if cohort=='production' else ('ordinary',)):
     for metric,col in ([('ns',6)] if series=='wall' else [('instructions',7),('cycles',8)]):
      prev,cur=([statistics.mean(v[col] for v in allr if v[1]==scope and v[3]==r and v[5].startswith(m)) for r in range(reps)] for m in ['prior','new']);delta=[y-x for x,y in zip(prev,cur)];z=[name,scope,series,metric,statistics.median(prev),statistics.median(cur),statistics.median(delta),min(delta),max(delta),sum(x<0 for x in delta),reps];pt.writerow(z);print(z,flush=True)
