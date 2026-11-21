from pathlib import Path
import os,sys,subprocess,random,csv,hashlib,json,statistics,time
cc,parent=map(Path,sys.argv[1:3]);out=Path(sys.argv[3]);out.mkdir(exist_ok=True,parents=True);args=sys.argv[4:]
base={k:'1' for k in ('NODE_SOURCE_QUIET','NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_PROOF_NATIVE','NODE_SOURCE_ROWS','NODE_SPLICE_FRONT','NODE_SOURCE_STRINGS','NODE_SOURCE_REFRESH_POINTERS','NODE_SOURCE_LOCAL_ACCESS','NODE_SOURCE_COMPACT','NODE_SOURCE_COMPACT_FULL','NODE_SOURCE_COMPACT_READS')}
modes={'parent':(parent,[],{}),'plain':(cc,[],{}),'legacy':(cc,[],base),'dry':(cc,['--node-window-source'],{'NODE_SOURCE_COMPACT_DRY':'1'}),'lean':(cc,['--node-window-source'],{})}
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))}); data=[];hashes=set()
with (out/'runs.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['round','mode','instructions','usercycles','kernelcycles','faults','wall_ms','sha256'])
 for r in range(8):
  order=list(modes);random.Random(2741+r).shuffle(order)
  for m in order:
   exe,flags,env=modes[m];target=out/'x.o';pc=out/'pmu';target.unlink(missing_ok=True)
   cmd=[str(exe),'--lanes','1','-c',*flags,*args,'-o',str(target)]
   if r:cmd=['perf','stat','-x,','-o',str(pc),'-e','instructions:u,cycles:u,cycles:k,minor-faults','--',*cmd]
   before=time.monotonic_ns();p=subprocess.run(cmd,capture_output=True,env={**os.environ,**env});ms=(time.monotonic_ns()-before)/1e6
   assert (p.returncode,p.stdout,p.stderr)==(0,b'',b''),(m,p.returncode,p.stderr[-1000:])
   sha=hashlib.sha256(target.read_bytes()).hexdigest();hashes.add(sha)
   if r:
    counts={v[2]:int(v[0]) for l in pc.read_text().splitlines() if len(v:=l.split(','))>=3 and v[0].isdigit()}
    values=tuple(counts[k] for k in ['instructions:u','cycles:u','cycles:k','minor-faults'])+(ms,)
    w.writerow((r,m,*values,sha));f.flush();data.append((r,m,values))
assert len(hashes)==1
outdata={}
for a,b in [('plain','parent'),('legacy','plain'),('dry','plain'),('lean','dry'),('lean','plain'),('lean','legacy')]:
 x=[[next(v[k] for i,m,v in data if i==r and m==a)-next(v[k] for i,m,v in data if i==r and m==b) for r in range(1,8)] for k in range(5)]
 outdata[a+' minus '+b]=dict(zip(['instructions','usercycles','kernelcycles','faults','wall_ms'],[[statistics.median(z),min(z),max(z)] for z in x]))
for m in modes:
 outdata['absolute '+m]=dict(zip(['instructions','usercycles','kernelcycles','faults','wall_ms'],[statistics.median([v[k] for i,mode,v in data if mode==m]) for k in range(5)]))
print(json.dumps(outdata,indent=2))
