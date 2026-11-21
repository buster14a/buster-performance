"""Report paired hardware results. Input is a copied remote results directory."""
from pathlib import Path
from statistics import median
import re,sys
d=Path(sys.argv[1])
for phase in ('cost','full','cycles','instructions','misses_clean','branches'):
 for corpus in ('sqlite','lua','musl'):
  for mode in ('lean','whole'):
   results={}
   for path in d.glob(f'{phase}-{corpus}-{mode}-*-*.done'):
    _,_,_,round_id,variant=path.stem.split('-')
    r=int(round_id)
    txt=path.with_suffix('.txt').read_text()
    records=int(re.search(r'node-facts: variant=\S+ records=(\d+)',txt)[1])
    if phase=='cost':
      produce,kernel,counts=map(int,re.search(r'subscript-cost: producer=(\d+) given-and-kernel=(\d+) records=(\d+)',txt).groups())
      assert records==counts and produce>0 and kernel>0
      vals=[produce/records,kernel/records,(produce+kernel)/records]
    elif phase=='full':
      totals={}
      for line in path.with_suffix('.stat').read_text().splitlines():
        f=line.split(';')
        if len(f)>2 and f[0].isdigit(): totals[f[2]]=int(f[0])
      vals=[totals[e]/records for e in ('cycles:u','instructions:u','branch-misses:u')]
    else:
      if r==1:continue
      stats=path.with_suffix('.events').read_text()
      assert 'THROTTLE' not in stats and 'LOST events' not in stats,path
      n=int(re.search(r'lookup=\[\] records=(\d+)',txt)[1])
      passes=int(re.search(r'time sweeps=T passes=(\d+)',txt)[1]); assert passes==120
      samples=int(re.search(r'(\d+)\s+\[\.\] node_facts_subscripts(?:_lean)?\s*$',path.with_suffix('.symbols').read_text(),re.M)[1])
      period={'cycles':300007,'instructions':800011,'misses_clean':5003,'branches':100003}[phase]
      vals=[samples*period/(n*(3*passes+3))]
    results.setdefault(r,{})[variant]=vals
   pairs=[(r,k['base'],k['project']) for r,k in sorted(results.items()) if 'base' in k and 'project' in k]
   if not pairs:continue
   print(f'{phase} {corpus} {mode}')
   for num in range(len(pairs[0][1])):
    a=[base[num] for _,base,_ in pairs];b=[project[num] for _,_,project in pairs];ds=[n-o for n,o in zip(b,a)]
    print('  [%d] paired=%d base=%.3f project=%.3f difference=%+.3f [%.3f, %.3f] raw=%s'%(num,len(a),median(a),median(b),median(ds),min(ds),max(ds),','.join('%+.3f'%x for x in ds)))
