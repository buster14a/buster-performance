from pathlib import Path
from statistics import median
import re
d=Path(__file__).resolve().parent; q=d/'qualification'
for sub in ['active-source-screens','active-source-final','active-source-name-screen','active-source-spans-screen','active-source-batches-screen']:
 p=q/sub
 if not p.exists():continue
 buckets={}
 for f in sorted(p.glob('[1-3]-*-*.tsv')):
  r,n,name=f.stem.split('-')
  vals=[float(l.split()[0])*1e-6 for l in f.read_text().splitlines() if l.strip()]
  buckets.setdefault(name,{}).setdefault(r,[]).extend(vals)
 for name,rounds in buckets.items():
  print(sub,name,'stage',round(median(v for values in rounds.values() for v in values),5),'rounds',*[round(median(v),5) for v in rounds.values()])
 for name in buckets:
  wall=[]
  for f in sorted(p.glob('*-'+name+'.wall')):
   wall+=list(map(float,re.findall(r'^run \d+ list 1: ([\d.]+) ms wall',f.read_text(),re.M)))
  if wall:print(sub,name,'whole process',round(median(wall),5),'n',len(wall))
p=q/'active-direct-sqlite-wall'
for arm in ['baseline','candidate']:
 vals=[]
 for f in p.glob('*-'+arm+'.wall'):
  vals+=list(map(float,re.findall(r'^run \d+ list 1: ([\d.]+) ms wall',f.read_text(),re.M)))
 if vals: print('ordinary -c',arm,median(vals),len(vals))
