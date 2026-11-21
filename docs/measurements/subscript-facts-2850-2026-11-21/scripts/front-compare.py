from pathlib import Path
import sys,re
d=Path(__file__).resolve().parent
for corpus in ('sqlite','lua','musl'):
 def read(v):
    ans={}
    for line in (d/('front-%s-%s.txt'%(corpus,v))).read_text().splitlines():
       for match in re.finditer(r"(([A-Za-z][A-Za-z0-9']*-)*(?:differences|differ|unmade|failures|mismatches))=(\d+)",line):
          key=(line.split(':',1)[1].split('=')[0],match[1])
          ans[key]=int(match[3])
    return ans
 a,b=read('base'),read('project')
 assert a==b and len(a)>=15,(corpus,a,b)
 print(corpus,len(a),'nonzero',[(k,v) for k,v in a.items() if v!=0])
