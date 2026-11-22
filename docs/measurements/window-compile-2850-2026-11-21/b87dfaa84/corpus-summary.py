from pathlib import Path
import csv,sys,collections
p=Path(__file__).resolve().parent
for g in sys.argv[1:]:
 d=p/g;summary=collections.Counter();by=collections.Counter()
 for name in ['sqlite','main','lua','musl']:
  rs=list(csv.DictReader((d/(name+'.tsv')).open(),delimiter='\t'))
  for r in rs:
   ok=r['ref-exit']==r['local-exit'] and all(r[k]=='1' for k in ['obj-equal','stdout-equal','stderr-equal'])
   summary['pairs']+=1;summary['matches']+=ok;summary['intended rejection']+=r['ref-exit']!='0'
   if not ok:by[r['file']]+=1
 print(g,summary,by)
