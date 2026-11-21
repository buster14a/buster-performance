from pathlib import Path
from statistics import mean, median
import sys
p=Path(sys.argv[1])
print('pages\tmetric\tbaseline\tcandidate\tmedian change\tminimum change\tmaximum change')
for mode in ('base','huge'):
  samples={}
  for r in range(1,8):
    for i in range(4):
      matches=list(p.glob(f'{r}-{mode}-{i}-*.stat'))
      assert len(matches)==1
      f=matches[0]
      d={s[2]:float(s[0]) for l in f.read_text().splitlines() if ';' in l and (s:=l.split(';')) and s[0].isdigit()}
      d['cycles per token']=(d['cycles:u']+d['cycles:k'])/716136
      d['user cycles per token']=d['cycles:u']/716136
      d['kernel cycles per token']=d['cycles:k']/716136
      tag='before' if f.stem.endswith('before') else 'after'
      samples.setdefault((r,tag),[]).append(d)
  for metric in ['cycles per token','user cycles per token','kernel cycles per token','instructions:u','instructions:k','minor-faults','major-faults','cpu-migrations']:
    cols=[[mean(x[metric] for x in samples[r,t]) for r in range(1,8)] for t in ['before','after']]
    change=[b-a for a,b in zip(*cols)]
    print(mode,metric,*['%.4f'%val for val in (median(cols[0]),median(cols[1]),median(change),min(change),max(change))],sep='\t')
