from pathlib import Path
import sys,csv,json,statistics
from collections import defaultdict
d=Path(sys.argv[1]); by=defaultdict(list)
with (d/'samples.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow(['workload','round','position','arm','metric','value'])
 for path in sorted(d.rglob('*.time')):
  g,_,r,pos,arm=path.stem.split('-')
  vals=json.loads(path.read_text());assert vals.pop('status')==0
  pmu=path.with_suffix('.pmu')
  if pmu.exists():
   for l in pmu.read_text().splitlines():
    if ';' in l:
     a=l.split(';');assert float(a[4])==100;vals[a[2]]=float(a[0])
  for name,n in vals.items():
   w.writerow([g,r,pos,arm,name,n]);by[g,name,int(r),arm].append(n)
with (d/'paired.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow(['workload','metric','rounds','dense','candidate','paired-difference','low','high','lower'])
 for g,m in sorted({(k[0],k[1]) for k in by}):
  rounds=sorted({k[2] for k in by if k[:2]==(g,m)})
  assert all(len(by[g,m,r,a])==2 for r in rounds for a in ['dense','batch'])
  arms=[[statistics.mean(by[g,m,r,a]) for r in rounds] for a in ['dense','batch']]
  ds=[b-a for a,b in zip(*arms)];w.writerow([g,m,len(ds),*(round(n,4) for n in [*(statistics.median(ar) for ar in arms),statistics.median(ds),min(ds),max(ds)]),sum(n<0 for n in ds)])
