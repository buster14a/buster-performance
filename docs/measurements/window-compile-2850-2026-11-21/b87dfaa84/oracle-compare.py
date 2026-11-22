from pathlib import Path
import sys,struct,mmap,collections,array,json
p=Path(__file__).resolve().parent;t=sys.argv[1];meta=struct.Struct('<27I8Q');u=struct.Struct('<I');arg=struct.Struct('<3I');none=0xffffffff
def trace(name):
 with (p/(t+'.'+name+'.graph')).open('rb') as f, mmap.mmap(f.fileno(),0,access=mmap.ACCESS_READ) as m:
  count=u.unpack_from(m,0)[0];i=4
  for n in range(count):
   v=meta.unpack_from(m,i);i+=meta.size
   a=[]
   for _ in range(v[5]):a.append(arg.unpack_from(m,i));i+=arg.size
   yield v,a
  assert i==len(m),(i,len(m))
plans={int(r[5]):list(map(int,r[1:])) for line in (p/(t+'.chain.stderr')).read_text().splitlines() if (r:=line.split()) and r[0]=='source-chain'}
old=iter(trace('base'));new=trace('chain');mapped=array.array('I');counts=collections.Counter();different=collections.Counter();samples=[]
def check(tag,x,y,i):
 if x!=y:
  different[tag]+=1
  if len(samples)<8:samples.append((tag,i,x,y))
def remap(x):
 if x==none:return x
 if x>=len(mapped):return -1
 return mapped[x]
for j,(v,va) in enumerate(new):
 r,ra=next(old)
 if j in plans:
  base,last,depth,entries,_,ty=plans[j]
  check('source base',(r[0],r[1]),(0,base),j)
  for i in range(depth):
   oldid=len(mapped);mapped.append(none)
   r,ra=next(old);check('nested edge',r[2],oldid,j);check('nested operator',r[0] in (32,33),True,j)
  check('terminal token',(r[1],v[1],v[0]),(last,last,0),j)
  # The sole retained lvalue has no input edge. Its native batch already carries the per-hop input conversions and offsets.
  check('terminal value',r[6:19]+r[27:34],v[6:19]+v[27:34],j)
  counts['hops']+=depth;counts['chains']+=1;counts['batch_rows']+=entries
 else:
  check('operator/token',r[:2],v[:2],j)
  check('retained state',r[6:],v[6:],j)
  for i in [2,3,4]:
   check('ordinary operand',remap(r[i]),v[i],j)
   counts['ordinary-edges']+=r[i]!=none
  check('arguments',[(remap(k),ty,fl) for k,ty,fl in ra],va,j);counts['arguments']+=len(ra)
 mapped.append(j);counts['retained']+=1
assert next(old,None) is None
data=(p/(t+'.chain.typed')).read_bytes();i=0
while i<len(data):
 count=u.unpack_from(data,i)[0];i+=4+10*count;counts['tier0_rows']+=count;counts['tier0_functions']+=1
assert i==len(data)
out={'input':t,'ordinary_graph_nodes':len(mapped),**counts,'mismatches':dict(different),'examples':samples};print(json.dumps(out));(p/(t+'.oracle.json')).write_text(json.dumps(out,indent=2));assert not different
