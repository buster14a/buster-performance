import sys
from pathlib import Path
from collections import Counter
def report(d, names):
 for name in names:
  cats={}; sources=0
  for line in (d/(name+'.err')).read_text(errors='replace').splitlines():
   if line.startswith('probe-access branch='):
    fields=dict(x.split('=') for x in line.split()[1:]); group='branch='+fields.pop('branch')
   elif line.startswith('probe-access kinds '):
    group='effects';fields=dict(x.split('=') for x in line.split()[2:]);sources+=1
   elif line.startswith('probe-entry '):
    group='entry';fields=dict(x.split('=') for x in line.split()[1:])
   elif line.startswith('probe-extra kind='):
    fields=dict(x.split('=') for x in line.split()[1:]); group='extra='+fields.pop('kind')
   else: continue
   cats.setdefault(group,Counter()).update({k:int(v) for k,v in fields.items()})
  for group,c in cats.items(): print(name,sources,group,*(f'{k}={v}' for k,v in c.items()))
if __name__=='__main__': report(Path(sys.argv[1]),sys.argv[2:])
