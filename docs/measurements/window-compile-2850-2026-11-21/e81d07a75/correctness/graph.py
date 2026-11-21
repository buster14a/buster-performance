from pathlib import Path
from collections import defaultdict,Counter
import struct,re,sys,json
none=2**32-1
def load(name):
 data=Path(name).read_bytes();n,argc,vs,cs,ac,nt=struct.unpack_from('<6I',data)
 stride=40+vs+cs+8
 def row(i):
  at=24+i*stride;return struct.unpack_from('<10I',data,at),data[at+40:at+40+vs],data[at+40+vs:at+stride]
 pos=24+n*stride;args=struct.unpack_from(f'<{argc}I',data,pos);pos+=4*argc
 cv=[data[pos+ac*i:pos+ac*(i+1)] for i in range(argc)]
 assert len(data)==pos+ac*argc
 return [row(i) for i in range(n)],args,cv,nt
def compare(a,b,log):
 old,args,ac,nt=load(a);new,argv,nc,nnt=load(b)
 keys=[tuple(map(int,m)) for m in re.findall(r'plain-call: token=(\d+) callee=(\d+) args=(\d+) rows=(\d+)',Path(log).read_text())];remove=set();summaries=set();stats=Counter();sampled={}
 by=defaultdict(list)
 for i,(h,v,c) in enumerate(old):by[h[0]].append(i)
 for token,callee,argc,_ in keys:
  hits=[n for n in by[token] if old[n][0][1] in (24,36) and old[n][0][2]!=none and old[old[n][0][2]][0][1]==34]
  assert len(hits)==1,(token,callee,hits)
  root=hits[0];call=old[root][0][2];h=old[call][0];assert h[6]==argc and old[h[2]][0][0]==callee
  gone={call,h[2],*args[h[5]:h[5]+argc]};assert not remove.intersection(gone)
  remove.update(gone);summaries.add(root)
 survive=[i for i in range(len(old)) if i not in remove];assert len(survive)==len(new),(len(old),len(new),len(remove),len(keys))
 remap=dict(zip(survive,range(len(survive))))
 for j,i in enumerate(survive):
  h,v,c=old[i];g,w,e=new[j];summary=i in summaries
  differences=[]
  if not (h[0]==g[0] and h[1]==g[1] if not summary else h[0]==g[0] and g[1]==0):differences+=['token/op']
  if v!=w:differences+=['value']
  if h[7:]!=g[7:]:differences+=['diagnostics']
  if not summary:
   for oi,ni in zip(h[2:5],g[2:5]):
    stats['edges']+=oi!=none
    if (none if oi==none else remap.get(oi,-1))!=ni:differences+=['edge']
   if c!=e:differences+=['conversions/member']
   if h[6]!=g[6]:differences+=['argument count']
   for pa,pb in zip(range(h[5],h[5]+h[6]),range(g[5],g[5]+g[6])):
    stats['arguments']+=1
    if remap.get(args[pa],-1)!=argv[pb]:differences+=['argument edge']
    if ac[pa]!=nc[pb]:differences+=['argument conversion']
  for kind in differences:
   stats['bad '+kind]+=1;sampled.setdefault(kind,(h[0],i,j,h[1],g[1],[k for k,(x,y) in enumerate(zip(v,w)) if x!=y][:12]))
 return dict(ordinary=len(old),compacted=len(new),calls=len(keys),removed=len(remove),old_types=nt,new_types=nnt,summary_values=len(summaries),stats=dict(stats),samples=sampled)
if __name__=='__main__':print(json.dumps(compare(*sys.argv[1:]),indent=2))
