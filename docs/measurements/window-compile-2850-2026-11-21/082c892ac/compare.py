from pathlib import Path
from collections import Counter
import csv
d=Path(__file__).resolve().parent
for name in ('sqlite','main'):
 def read(mode):
  p=d/f'{name}.{mode}.log'
  rows={}
  for l in p.read_text().splitlines():
   if l.startswith('body-'+mode+'-row\t'):
    _,close,n,digest=l.split('\t')
    close=int(close)
    assert close not in rows
    rows[close]=(int(n),digest)
  return rows
 source=read('source')
 whole=read('whole')
 kinds=Counter()
 with (d/f'{name}.comparison.tsv').open('w') as f:
  out=csv.writer(f,delimiter='\t')
  out.writerow(('close_token','source_nodes','whole_nodes','source_digest','whole_digest','result'))
  for close,(n,h) in source.items():
   m,hd=whole.get(close,(-1,''))
   kind='exact' if (n,h)==(m,hd) else 'missing' if m<0 else 'node-count' if m!=n else 'digest'
   out.writerow((close,n,m,h,hd,kind));kinds[kind]+=1
 print(name,'source',len(source),'ordinary',len(whole),'categories',dict(kinds),'exact-nodes',sum(n for close,(n,h) in source.items() if (n,h)==whole.get(close)),'max-exact',max((n for close,(n,h) in source.items() if (n,h)==whole.get(close)),default=0))
