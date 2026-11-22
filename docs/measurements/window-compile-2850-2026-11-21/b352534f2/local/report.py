from pathlib import Path
import csv,statistics,sys
p=Path(__file__).resolve().parent
if sys.argv[1]=='scout':
 files=[(f.stem.split('.')[-1],f) for f in sorted(p.glob('sqlite.profile*.stderr'))]
else:
 files=[(f.stem.rsplit('-',1)[-1],f) for f in sorted(p.glob('develop-*-profile*.stderr'))]
by={}
for arm,f in files:
 lines=[s.split('\t') for s in f.read_text().splitlines() if s.startswith('source-cost')];wall=int(next(r[1] for r in lines if r[0]=='source-cost-wall'))/1e6;raw={r[1]:int(r[2]) for r in lines if r[0]=='source-cost'};d={k:v*wall/sum(raw.values()) for k,v in raw.items()};d['TOTAL']=wall
 for k,v in d.items():by.setdefault(k,{}).setdefault(arm,[]).append(v)
arms=sorted(set(a for row in by.values() for a in row));print('\t'.join(['phase',*arms]));
for k,row in sorted(by.items(),key=lambda q:-statistics.median(q[1].get(arms[-1],[0]))):print('\t'.join([k,*(str(round(statistics.median(row[a]),3)) for a in arms)]))
