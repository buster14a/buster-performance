from pathlib import Path
from collections import Counter
import re,sys
for path in map(Path,sys.argv[1:]):
 c=Counter();roots=Counter();wrong=set();last=0
 for line in path.open():
  if line.startswith('source-conditions '):
   kept,rows=map(int,re.findall('[0-9]+',line));c['retained']+=kept;c['rows']+=rows
  if line.startswith('row-locations:'):last+=1
  if line.startswith('loc-row '):
   root,op,tok,n,i,sub,k,got,left,right,prev,parent,want,owner,cls,cast=map(int,line.split()[1:])
   if op!=37:continue
   key=(last,root,tok);roots[key]+=1;c['checked']+=1
   if got!=want:
    c['different']+=1;wrong.add(key)
    if c['different']<=4:print('wrong',last,tok,i,sub,k,got,want)
 print(path.name,'retained',c['retained'],c['rows'],'reached',len(roots),'entries',c['checked'],'origin miss',c['different'],'roots affected',len(wrong))
