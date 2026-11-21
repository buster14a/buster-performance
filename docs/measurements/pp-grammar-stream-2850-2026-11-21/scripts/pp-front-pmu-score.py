"""Read inclusive on-CPU hardware counts from the real driver, without converting time to cycles."""
from pathlib import Path
from statistics import median
from collections import defaultdict
import sys
root=Path(sys.argv[1])
series=defaultdict(lambda:defaultdict(dict))
for label in ('frontpmubase','frontpmusized'):
 d=root/(label+'-time')
 if not (d/'status').is_file():continue
 for line in (d/'status').read_text().splitlines():
  run,source,alloc=line.split();f=d/f'{run}-{source}-{alloc}.log'
  found=0
  for l in f.read_text().splitlines():
   if not l.startswith('front-pmu '):continue
   row={k:int(i) for k,i in (cell.split('=') for cell in l.split()[1:])}
   assert row['semantic']==1 and row['deferred']==1 and row['tokens']>0,(f,row)
   assert all(row[e+'-enabled']>0 and row[e+'-running']>=.995*row[e+'-enabled'] for e in ('pp','front')),(f,row)
   unit='cycles' if row['event']==0 else 'instructions'
   for metric,count in [('PP-through-return',row['pp']),('after-PP-through-parse',row['front']-row['pp']),('PP-entry-through-parse',row['front'])]:
    series[source,alloc,metric,unit][label][run]=count/row['tokens']
   found+=1
  assert found==2,f
print('source','allocation','phase','unit/token','parent rounds','parent median','sized rounds','sized median','paired median %','paired min %','paired max %',sep='\t')
for (source,alloc,phase,unit),values in sorted(series.items()):
 a=values['frontpmubase'];b=values['frontpmusized']
 diff=[100*(b[r]/a[r]-1) for r in a if r in b]
 show=lambda v: f'{v:.3f}' if v is not None else ''
 print(source,alloc,phase,unit,len(a),show(median(a.values()) if a else None),len(b),show(median(b.values()) if b else None),show(median(diff) if diff else None),show(min(diff) if diff else None),show(max(diff) if diff else None),sep='\t')
