from common import *
from statistics import median
import csv,hashlib,subprocess,time
subprocess.run(['python3',W/'source-counted-parent-study/ensure.py'],check=True)
PRIOR=W/'source-counted-parent/build/compiler'
out=D/'process';out.mkdir(exist_ok=True);flags=args['sqlite'];expected=hashlib.sha256((W/'source-typed-study/sqlite.o').read_bytes()).hexdigest();obj=out/'sqlite.o'
modes={'prior-ordinary':(PRIOR,{}),'prior-source':(PRIOR,native),'source-control':(CC,native),'source-producer':(CC,native|producer)}
names=list(modes);schedule=[[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]]
samples=[]
with (out/'samples.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('series','round','position','mode','ns','instructions','cycles','ELF'))
 for series,reps in [('wall',8),('pmu',4)]:
  for r in range(reps):
   order=schedule[r%4];order=order if r<4 else order[::-1]
   for k,i in enumerate(order):
    mode=names[i];cc,e=modes[mode];stem=out/f'{series}.{r}.{k}.{mode}';cmd=[cc,'--lanes','1','-c',*flags,'-o',obj];pm=Path(str(stem)+'.perf')
    if series=='pmu':cmd=['perf','stat','-x,','--no-big-num','-e','instructions:u,cycles:u','-o',pm,'--',*cmd]
    start=time.monotonic_ns();res=subprocess.run(cmd,env=env|e,cwd=ROOT,capture_output=True);end=time.monotonic_ns();assert res.returncode==0,(mode,res.stderr[:300]);sha=hashlib.sha256(obj.read_bytes()).hexdigest();assert sha==expected;Path(str(stem)+'.stderr').write_bytes(res.stderr)
    stats=({z[2]:int(z[0]) for z in csv.reader(pm.read_text().splitlines()) if len(z)>2} if pm.exists() else {}); row=[series,r,k,mode,end-start,stats.get('instructions:u',''),stats.get('cycles:u',''),sha];t.writerow(row);samples.append(row)
with (out/'paired.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('control','producer','series','metric','control-median','producer-median','median-delta','faster','rounds'))
 for series,n,metric,col in [('wall',8,'ns',4),('pmu',4,'instructions',5),('pmu',4,'cycles',6)]:
  vs={m:[z[col] for z in samples if z[0]==series and z[3]==m] for m in modes};b=vs['source-producer']
  for m,a in vs.items():
   if m=='source-producer':continue
   delta=[y-x for x,y in zip(a,b)];t.writerow([m,'source-producer',series,metric,median(a),median(b),median(delta),sum(v<0 for v in delta),n])
