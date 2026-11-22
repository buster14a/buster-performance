import csv,json,statistics
from pathlib import Path
d=Path(__file__).resolve().parent;ts=d/'target-raw/target';wall=d/'target-raw/target-wall';out=d/'target'
def rows(p):return list(csv.DictReader(p.open(),delimiter='\t'))
def table(p,r):
 with p.open('w') as f:
  w=csv.DictWriter(f,fieldnames=r[0].keys(),delimiter='\t',lineterminator='\n');w.writeheader();w.writerows(r)
c=rows(ts/'samples.tsv');w=rows(wall/'samples.tsv');assert len(c)==40 and len(w)==40
for n in ('sqlite','main'):
 a={(r['ELF'],r['stdout'],r['stderr']) for r in c+w if r['input']==n};assert len(a)==1,(n,a)
 for g in (c,w):
  for i in range(1,6):
   rr=[r for r in g if r['input']==n and r['round']==str(i)];assert [r['arm'] for r in rr]==(['parent','candidate','candidate','parent'] if i%2 else ['candidate','parent','parent','candidate'])
 for r in c:
  if r['input']==n:
   j=json.loads((ts/('.'.join([n,r['round'],r['position'],r['arm']])+'.json')).read_text());r['perf-process-wall-ns']=j['process-ns'];r['perf-duration-event']=r.pop('duration-ns');assert j['affinity']==[2] and r['migrations']=='0'
a=[r for r in rows(ts/'summary.tsv') if r['metric']!='duration-ns']+rows(wall/'summary.tsv');table(out/'summary.tsv',a);table(out/'samples.tsv',c)
assert len(a)==6
