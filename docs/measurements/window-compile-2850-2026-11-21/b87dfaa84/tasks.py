from pathlib import Path
from collections import Counter
import csv
p=Path(__file__).resolve().parent
with (p/'tasks.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['input','metric','base','chain','eliminated'])
 for name in ['probe','sqlite','main']:
  metrics=[]
  for arm in ['base','chain']:
   c=Counter()
   for line in (p/f'{name}.tasks.{arm}.stderr').open():
    v=line.split()
    if v and v[0]=='chain-task':c['kind-'+v[1]]+=int(v[2])
    if v and v[0]=='chain-expansions':c['graph-expansions']+=int(v[1]);c['tape-splices']+=int(v[2])
   c['task-pops']=sum(value for key,value in c.items() if key.startswith('kind-'));metrics.append(c)
  for key in sorted(metrics[0].keys()|metrics[1].keys()):
   a,b=(c[key] for c in metrics);out.writerow([name,key,a,b,a-b])
  print(name,[(k,[q[k] for q in metrics]) for k in ['task-pops','graph-expansions','tape-splices']])
