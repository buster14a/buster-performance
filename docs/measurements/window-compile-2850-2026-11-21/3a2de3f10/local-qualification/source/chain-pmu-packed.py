from pathlib import Path
import os,sys,subprocess,hashlib,csv,random,statistics
cc=Path(sys.argv[1]).resolve(); d=Path(sys.argv[2]).resolve(); args=sys.argv[3:]
cpu=min(os.sched_getaffinity(0)); os.sched_setaffinity(0,{cpu})
modes=[('regular',{},[]),('packed',{'BUSTER_CHAIN_PACKED':'1'},[]),('window',{},['--node-window']),('window-packed',{'BUSTER_CHAIN_PACKED':'1'},['--node-window'])]
checks=set()
with (d/'chain-pmu.tsv').open('w') as output:
 f=csv.writer(output,delimiter='\t',lineterminator='\n');f.writerow('round position mode instructions usercycles syscycles faults sha256'.split())
 for r in range(8):
  random.Random(171+r).shuffle(modes)
  for i,(mode,env,flags) in enumerate(modes):
   obj=d/'chain-local.o'; raw=d/'chain-local-perf'
   cmd=[str(cc),*flags,'--lanes','1','-c',*args,'-o',str(obj)]
   if r:cmd=['perf','stat','-x,','-e','instructions:u,cycles:u,cycles:k,page-faults','-o',str(raw),'--',*cmd]
   res=subprocess.run(cmd,env=dict(os.environ,**env),capture_output=True,check=True)
   assert not res.stdout and not res.stderr
   h=hashlib.sha256(obj.read_bytes()).hexdigest(); checks.add(h)
   if r:
    v={p[2]:int(p[0]) for l in raw.read_text().splitlines() if len(p:=l.split(','))>4 and p[0].isdigit()}
    f.writerow((r,i,mode,v['instructions:u'],v['cycles:u'],v['cycles:k'],v['page-faults'],h))
assert len(checks)==1
