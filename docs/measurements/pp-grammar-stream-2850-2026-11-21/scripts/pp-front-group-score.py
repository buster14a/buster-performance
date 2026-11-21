from pathlib import Path
from collections import defaultdict
from statistics import median
import sys
d=Path(sys.argv[1]);groups=defaultdict(lambda:defaultdict(dict))
for line in (d/'status').read_text().splitlines():
 run,source,tag=line.split();variant,alloc=tag.split('-')
 lines=[s for s in (d/(run+'-'+source+'-'+tag+'.log')).read_text().splitlines() if s.startswith('front-group ')]
 assert len(lines)==1,(line,lines)
 row={k:int(v) for k,v in (cell.split('=') for cell in lines[0].split()[1:])}
 assert row['semantic']==row['deferred']==1 and row['tokens']>0,(line,row)
 assert all(row[s+'-running']>=0.995*row[s+'-enabled']>0 for s in ('pp','front')),(line,row)
 n=row['tokens']
 for stage in ('pp','front'):row[stage+'-total']=row[stage+'-user']+row[stage+'-kernel']
 for metric in ('user','kernel','total','instructions'):
  for phase,count in [('PP-through-return',row['pp-'+metric]),('after-PP-through-parse',row['front-'+metric]-row['pp-'+metric]),('PP-entry-through-parse',row['front-'+metric])]:
   groups[source,alloc,phase,metric][variant][run]=count/n
print('source','allocation','phase','event/token','parent rounds','parent median','sized rounds','sized median','paired median %','paired min %','paired max %',sep='\t')
for keys,data in sorted(groups.items()):
 a=data['base'];b=data['sized'];du=[100*(b[r]/a[r]-1) for r in a if a[r] and r in b]
 show=lambda v:f'{v:.3f}' if v is not None else ''
 print(*keys,len(a),show(median(a.values()) if a else None),len(b),show(median(b.values()) if b else None),show(median(du) if du else None),show(min(du) if du else None),show(max(du) if du else None),sep='\t')
