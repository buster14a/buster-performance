from pathlib import Path
import os,sys,random,subprocess,csv,re,statistics,hashlib
from collections import defaultdict
cost=Path(sys.argv[1]).resolve(); discovery=Path(sys.argv[2]).resolve(); d=Path(sys.argv[3]).resolve(); d.mkdir(parents=True,exist_ok=True)
args=sys.argv[4:]
cpu=min(os.sched_getaffinity(0)); os.sched_setaffinity(0,{cpu})
tot=716136
modes={}
for st in 'off alloc controls discover front type rows full'.split():
 modes['cost-'+st]=(cost,['--node-window-conditions'],{'BUSTER_CONDITION_COST':st})
modes['split-off']=(discovery,['--node-window-assignments'],{})
for m in ('original','control','plain'):
 modes['split-'+m]=(discovery,['--node-window-assignments','--node-window-conditions'],{'BUSTER_CONDITION_DISCOVERY':m})
modes['split-normal']=(discovery,[],{})
def run(m,p):
 cc,flags,env=modes[m]; obj=d/'current.o'
 cmd=[str(cc),*flags,'--lanes','1','-c',*args,'-o',str(obj)]
 raw=d/'pmu'
 if p: cmd=['perf','stat','-x,','-e','instructions:u,cycles:u','-o',str(raw),'--',*cmd]
 proc=subprocess.run(cmd,env=dict(os.environ,**env),capture_output=True,check=True)
 assert not proc.stdout and not proc.stderr,(m,proc.stdout,proc.stderr)
 h=hashlib.sha256(obj.read_bytes()).hexdigest()
 if p: return (h,{f[2]:int(f[0]) for line in raw.read_text().splitlines() if len(f:=line.split(','))>4 and f[0].isdigit()})
 return h
hashes={run(m,False) for m in modes}; assert len(hashes)==1
values=defaultdict(list)
with (d/'processes.tsv').open('w') as output:
 writer=csv.writer(output,delimiter='\t',lineterminator='\n');writer.writerow(['round','position','mode','instructions','cycles','object_sha256'])
 for round_ in range(7):
  listing=list(modes); random.Random(1926+round_).shuffle(listing)
  for n,m in enumerate(listing):
   h,c=run(m,True); assert h in hashes
   v=c['instructions:u'],c['cycles:u']; values[m].append(v);writer.writerow((round_+1,n+1,m,*v,h))
  output.flush()
for m in modes:
 if m.startswith('cost-'):
  prev='cost-off' if m=='cost-off' else 'cost-'+('off alloc controls discover front type rows full'.split()['off alloc controls discover front type rows full'.split().index(m[5:])-1])
 else:prev='split-off'
 ix=[a[0]-b[0] for a,b in zip(values[m],values[prev])]
 cx=[(a[1]-b[1])/tot for a,b in zip(values[m],values[prev])]
 print(m,'vs',prev,'median instruction delta',statistics.median(ix),'range',min(ix),max(ix),'median cycles/token',round(statistics.median(cx),3),'range',round(min(cx),3),round(max(cx),3))
print('core',cpu,'compiled',len(modes)*8,'objects',hashes)
