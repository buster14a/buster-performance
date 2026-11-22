from pathlib import Path
from collections import Counter
import csv,hashlib
p=Path(__file__).resolve().parent.parent/'member-chain-statements-study'
with (p/'composition.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['input','arm','direct-statements','direct-statement-lower','chains','hops','rows','graph-rows','elf-sha256'])
 for name in ('probe','sqlite','main'):
  for arm in ('base','chain'):
   c=Counter()
   for l in (p/f'{name}.composed.{arm}.stderr').open():
    v=l.split()
    if not v:continue
    c[v[0]]+=1
    if v[0]=='source-chain':c['hops']+=int(v[3]);c['rows']+=int(v[4])
    if v[0]=='chain-graph':c['graph rows']+=int(v[4])-int(v[3])
   out.writerow([name,arm,c['direct-statement'],c['direct-statement-lower'],c['source-chain'],c['hops'],c['rows'],c['graph rows'],hashlib.file_digest((p/f'{name}.composed.{arm}.o').open('rb'),'sha256').hexdigest()])
