from pathlib import Path
from time import monotonic_ns
from statistics import median
import csv,subprocess,random,hashlib,os,sys,json
cc=Path(sys.argv[1]).resolve();out=Path(sys.argv[2]).resolve();out.mkdir(parents=True,exist_ok=True); args=sys.argv[3:]
base={k:'1' for k in ('NODE_SOURCE_QUIET','NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_PROOF_NATIVE','NODE_SOURCE_ROWS','NODE_SPLICE_FRONT','NODE_SPLICE_ENABLE','NODE_SOURCE_STRINGS','NODE_SOURCE_REFRESH_POINTERS','NODE_SOURCE_LOCAL_ACCESS')}
opts={k:'1' for k in ('NODE_SOURCE_COMPACT','NODE_SOURCE_COMPACT_FULL','NODE_SOURCE_COMPACT_READS')}
modes={'plain':{},'source':{**base,'NODE_SOURCE_ONLY':'1'},'dry':{**base,**opts,'NODE_SOURCE_COMPACT_DRY':'1'},'publish':{**base,**opts}}
cpu=min(os.sched_getaffinity(0));os.sched_setaffinity(0,{cpu}); hashes=set()
fields=['round','position','mode','instructions','usercycles','kernelcycles','faults','wall_ms','object_sha']
with (out/'runs.tsv').open('w') as f:
 w=csv.DictWriter(f,fields,delimiter='\t',lineterminator='\n');w.writeheader()
 for r in range(8):
  ordered=list(modes);random.Random(2173+r).shuffle(ordered)
  for i,m in enumerate(ordered):
   perf=out/'perf.tmp';obj=out/'frozen.o'
   cmd=[str(cc),'--lanes','1','-c',*args,'-o',str(obj)]
   if r:cmd=['perf','stat','-x,','-o',str(perf),'-e','instructions:u,cycles:u,cycles:k,minor-faults','--',*cmd]
   t=monotonic_ns();p=subprocess.run(cmd,env={**os.environ,**modes[m]},capture_output=True);ms=(monotonic_ns()-t)/1e6
   if p.returncode or p.stdout or p.stderr:
    (out/(m+'.stderr')).write_bytes(p.stderr);raise RuntimeError((m,p.returncode,p.stderr[-500:]))
   sha=hashlib.sha256(obj.read_bytes()).hexdigest();hashes.add(sha)
   if r:
    v={v[2]:int(v[0]) for l in perf.read_text().splitlines() if len(v:=l.split(','))>=3 and v[0].isdigit()}
    w.writerow(dict(round=r,position=i,mode=m,instructions=v['instructions:u'],usercycles=v['cycles:u'],kernelcycles=v['cycles:k'],faults=v['minor-faults'],wall_ms=ms,object_sha=sha));f.flush()
assert len(hashes)==1
rows=list(csv.DictReader((out/'runs.tsv').open(),delimiter='\t'))
def phase(label,a,b):
 out={}
 for k in ['instructions','usercycles','kernelcycles','faults','wall_ms']:
  paired=[float(next(x for x in rows if x['round']==str(r) and x['mode']==a)[k])-float(next(x for x in rows if x['round']==str(r) and x['mode']==b)[k]) for r in range(1,8)]
  out[k]={'delta_median':median(paired),'minimum':min(paired),'maximum':max(paired)}
 return label,out
print(json.dumps(dict([phase('producer source - plain','source','plain'),phase('discovery dry - source','dry','source'),phase('publication full - dry','publish','dry'),phase('actual full - plain','publish','plain')]),indent=2))
