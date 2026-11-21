"""Compare ELF symbol names, types and sizes, retaining duplicate local names."""
from collections import Counter
from pathlib import Path
import sys
def read(path):
 rows=Counter()
 for line in Path(path).read_text().splitlines():
  cols=line.split()
  if len(cols)==4:address,size,kind,name=cols
  elif len(cols)==3:address,kind,name=cols;size='0'
  else:raise ValueError(line)
  rows[(name,kind,int(size,16))]+=1
 return rows
a,b=map(read,sys.argv[1:3])
print('status\tname\ttype\tsize\tmultiplicity')
for status,diff in [('removed',a-b),('added',b-a)]:
 for (name,kind,size),n in sorted(diff.items()):
  print(status,name,kind,size,n,sep='\t')
print('shared',sum((a&b).values()),sep='\t',file=sys.stderr)
if len(sys.argv)>3 and sys.argv[3]=='tier1':
 assert list((a-b).elements()) and [n for n,k,s in (a-b).elements()]==['.Lbuster_string_15'] and not b-a
else:assert a==b
