from common import *
import csv,gzip,re
q=D/'oracle';rows=list(csv.DictReader((q/'clang.tsv').open(),delimiter='\t'));cases={x['case'] for x in rows}
def parse(hex):
 data=gzip.decompress((q/'streams'/(hex+'.gz')).read_bytes()).decode(errors='replace');items=[]
 for ln in data.splitlines():
  x=re.search(r'^(.*?):([0-9]+):([0-9]+):\s+(fatal error|error|warning|note):\s*(.*)',ln)
  if x:items.append((int(x[2]),int(x[3]),x[4],x[5]))
 return items
with (q/'clang-locations.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['input','mode','clang-events','compiler-events','same-locations-and-severities','same-messages','clang-stderr','compiler-stderr'])
 for c in sorted(cases):
  rr={r['mode']:r['stderr'] for r in rows if r['case']==c};oracle=parse(rr['clang'])
  for mode,h in rr.items():
   if mode=='clang':continue
   result=parse(h);t.writerow([c,mode,len(oracle),len(result),int([z[:3] for z in oracle]==[z[:3] for z in result]),int(oracle==result),rr['clang'],h])
