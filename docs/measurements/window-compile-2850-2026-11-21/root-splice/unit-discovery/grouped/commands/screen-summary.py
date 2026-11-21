from pathlib import Path
import csv,statistics,sys
d=Path(__file__).resolve().parent;p=d/sys.argv[1];rows=list(csv.DictReader((p/'screen-pmu.tsv').open(),delimiter='\t'));cs=list(dict.fromkeys(s['corpus'] for s in rows));cols=[('instructions',1e6),('user_cycles',1e6),('kernel_cycles',1e6),('faults',1),('elapsed_ms',1)];modes=list(dict.fromkeys(s['mode'] for s in rows));modes.sort()
with (p/'comparison.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['corpus','base','mode','n']+[k+suffix for k,_ in cols for suffix in ('_median','_min','_max')]);
 for c in cs:
  raw={(int(s['round']),s['mode']):s for s in rows if s['corpus']==c}
  for base in [s for s in ['plain','at0','full','parent','orig-plain','orig-full'] if s in modes]:
   for m in modes:
    if m==base:continue
    rounds=[i for i in range(1,4) if (i,m) in raw and (i,base) in raw]
    if not rounds:continue
    row=[c,base,m,len(rounds)]
    for col,factor in cols:
     ds=[(float(raw[i,m][col])-float(raw[i,base][col]))/factor for i in rounds];row.extend(round(x,6) for x in [statistics.median(ds),min(ds),max(ds)])
    t.writerow(row)
