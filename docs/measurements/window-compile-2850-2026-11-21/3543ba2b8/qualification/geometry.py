from pathlib import Path
from collections import Counter,defaultdict
import array,csv
s=Path(__file__).resolve().parent
with (s/'tile-edges.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','scope','tile','first','end-exclusive','roots','crossing-parents','distinct-external-targets','longest-cross-edge'])
 for source in ['sqlite','main']:
  parents=array.array('I',(s/'source-depths'/('candidate-'+source+'.bin.parents')).read_bytes());intervals=[('whole',0,len(parents))]
  if source=='main':
   end=829892;begin=next(i+1 for i in range(end-1,-1,-1) if parents[i]==2**32-1);intervals.append(('largest-initializer',begin,end+1))
  for name,start,stop in intervals:
   for first in range(start,stop,4096):
    end=min(stop,first+4096);roots=edges=longest=0;targets=set()
    for i in range(first,end):
     parent=parents[i]
     if parent==2**32-1:roots+=1
     elif not first<=parent<end:
      assert start<=parent<stop
      edges+=1;targets.add(parent);longest=max(longest,abs(parent-i))
    t.writerow([source,name,(first-start)//4096,first,end,roots,edges,len(targets),longest])

# A monotonic stack at each fixed boundary is sufficient to seed its left- or
# right-candidate search. Count complete incoming stacks on final source rows.
import re
src=(s.parent/'tile-parser-precedence/src/buster/compiler/c_parser.c').read_text()
decl=src.split('typedef enum ParseLevel',1)[1].split('} ParseLevel;',1)[0]
levels={};last=-1
for name,value in re.findall(r'^\s*PARSE_LEVEL_(\w+)(?:\s*=\s*(\d+))?,',decl,re.M):
 last=int(value) if value else last+1;levels[name]=last
rows=src.split('#define BUSTER_PARSE_ROLES(X)',1)[1].split('\n\n',1)[0]
role_levels=[levels[level] for level in re.findall(r'X\(\w+, (\w+),',rows)]
with (s/'precedence-carry.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','direction','tile','boundary','incoming-candidate-count'])
 for source in ['sqlite','main']:
  raw=s/'source-depths'/('candidate-'+source+'.bin');depths=raw.read_bytes();roles=Path(str(raw)+'.roles').read_bytes()
  for direction in ['left','right']:
   stack=[]
   ordering=range(len(roles)) if direction=='left' else range(len(roles)-1,-1,-1)
   for i in ordering:
    if (direction=='left' and i%4096==0) or (direction=='right' and (i+1==len(roles) or (i+1)%4096==0)):
     t.writerow([source,direction,i//4096,i,len(stack)])
    key=32*depths[i]+role_levels[roles[i]]
    while stack and stack[-1]>=key:stack.pop()
    stack.append(key)
