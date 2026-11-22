from collections import defaultdict
from pathlib import Path
from statistics import median, mean
import csv, json
base=Path(__file__).resolve().parent
rounds=defaultdict(lambda:defaultdict(list))
with (base/'samples.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n')
 metrics=['wall_ms','user_ms','system_ms','peak_kib','minor_faults']
 w.writerow(['input','token_limit','round','position','arm',*metrics])
 for p in sorted((base/'stage').glob('*.time')):
  group,limit,r,i,mode=p.stem.split('-')
  row=json.loads(p.read_text())
  assert row['status']==0
  vals=[row[k] for k in metrics];w.writerow([group,limit,r,i,mode,*vals])
  for k,v in zip(metrics,vals): rounds[group,int(limit),int(r),k][mode].append(v)
with (base/'paired.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n')
 w.writerow(['workload','limit','metric','pairs','one-median','batch-median','paired-median','range-low','range-high','faster'])
 for g in ['sqlite','main']:
  for limit in [256,1024,4096]:
   for metric in metrics:
    rs=[rounds[g,limit,r,metric] for r in range(1,6)]
    assert all(len(v['one'])==2 and len(v['batch'])==2 for v in rs)
    a=[mean(v['one']) for v in rs];b=[mean(v['batch']) for v in rs];diff=[j-i for i,j in zip(a,b)]
    w.writerow([g,limit,metric,5,*[round(v,5) for v in (median(a),median(b),median(diff),min(diff),max(diff))],sum(x<0 for x in diff)])
