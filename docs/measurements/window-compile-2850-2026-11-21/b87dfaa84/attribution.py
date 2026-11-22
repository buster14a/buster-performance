from pathlib import Path
from collections import Counter
import csv,re
p=Path(__file__).resolve().parent
with (p/'instruction-samples.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['configuration','symbol','off-samples','on-samples','sample-delta','instructions-per-sample'])
 for mode in ['ordinary','native']:
  arms=[]
  for arm in ['off','on']:
   c=Counter()
   for l in (p/f'{mode}-{arm}.profile').open():
    m=re.search(r'([0-9.]+)%\s+([0-9]+)\s+\[.\]\s+(\S+)',l)
    if m:c[m[3]]+=int(m[2])
   arms.append(c)
  a,b=arms
  for name in sorted(a.keys()|b.keys(),key=lambda k:b[k]-a[k],reverse=True):
   out.writerow([mode,name,a[name],b[name],b[name]-a[name],131089])
