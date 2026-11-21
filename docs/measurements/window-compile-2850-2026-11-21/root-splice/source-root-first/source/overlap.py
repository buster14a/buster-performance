from pathlib import Path
from collections import defaultdict,Counter
import sys,re,struct,json
p=Path(sys.argv[1]);raw=(p/'plain.bin').read_bytes()
n,argn,vs,cs=struct.unpack_from('<4I',raw);r=struct.Struct('<10I');step=r.size+vs+cs+8
rows=[r.unpack_from(raw,16+i*step) for i in range(n)];args=struct.unpack_from('<%dI'%argn,raw,16+n*step);none=2**32-1
def children(h):
 return [i for i in h[2:5] if i!=none]+list(args[h[5]:h[5]+h[6]])
s=(p/'original.err').read_text()
oracle={int(t):tuple(map(int,(node,k,w,op))) for t,node,k,w,op in re.findall(r'^splice-taken: token=(\d+) node=(\d+) k=(\d+) n=(\d+) op=(\d+)',s,re.M)}
def keys(m):return {int(t) for t in re.findall(r'^splice-taken: token=(\d+)',(p/(m+'.err')).read_text(),re.M)}
source=keys('source');taken={int(t) for t in re.findall(r'^compact-taken: token=(\d+)',(p/'compact.err').read_text(),re.M)}
bins=defaultdict(Counter)
owners={};overlap=0;entries=0
for t,(node,k,w,op) in oracle.items():
 h=rows[node];assert h[0]==t and h[1]==op and h[2]!=none
 top=h[2];seen={top};stack=[top]
 while stack:
  for j in children(rows[stack.pop()]):
   if j not in seen:seen.add(j);stack.append(j)
 for i in seen:
  overlap+=i in owners;owners[i]=(t,top)
 label='const_return' if op==36 and k==1 and w==1 else 'other_return' if op==36 else 'assignment'
 span=len(seen)
 for group in ('all',label):
  b=bins[group];b['roots']+=1;b['native_rows']+=w;b['single_operands']+=span==1;b['removable_if_wrapped']+=span-1;b['removable_if_whole']+=span;b['source_only_native']+=t in source;b['currently_shrunk']+=t in taken
for n,h in enumerate(rows):
 for c in children(h):
  if c in owners:
   f,top=owners[c]
   entries+=c!=top and (n not in owners or owners[n][0]!=f)
print(json.dumps(dict(bins=bins,overlap=overlap,enters_external_interior=entries),indent=2))
