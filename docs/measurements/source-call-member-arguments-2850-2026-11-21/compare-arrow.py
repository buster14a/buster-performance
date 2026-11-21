import os
from pathlib import Path
from collections import defaultdict,Counter
import json,re,struct,sys
import hashlib
here=Path(os.environ.get("BUSTER_CASE_DIR",Path(__file__).resolve().parent)).resolve()
sys.path.insert(0,str(Path(__file__).resolve().parent))
from graph import load,none
d=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else here
old,args,aconv,nt=load(d/'base.graph');new,narg,nconv,newt=load(d/'arrow.graph')
rlog=(d/'arrow.log').read_text()
extra={int(a):(int(m),int(n)) for a,m,n in re.findall(r'arrow-call: token=(\d+) members=(\d+) rows=(\d+)',rlog)}
roots={int(a):tuple(map(int,(n,k,r))) for a,n,k,r in re.findall(r'plain-call: token=(\d+) callee=(\d+) args=(\d+) rows=(\d+)',rlog)}
base={int(a) for a in re.findall(r'plain-call: token=(\d+)',(d/'base.log').read_text())}
assert set(extra)==set(roots)-base and len(extra)>0
by=defaultdict(list)
for i,(h,*_) in enumerate(old):by[h[0]].append(i)
ops=re.findall(r'^    CHECK_OP_(\w+),',(Path(os.environ['BUSTER_SRC'])/'src/buster/compiler/c_check_actions.c').read_text().split('typedef enum CheckOp\n')[1].split('} CheckOp;')[0],re.M)
removed=set();markers=set()
for token,(members,nrows) in extra.items():
 callee,argc,native=roots[token]
 hits=[n for n in by[token] if old[n][0][1] in (24,36) and old[n][0][2]!=none and old[old[n][0][2]][0][1]==34]
 assert len(hits)==1
 root=hits[0];call=old[root][0][2];h=old[call][0]
 assert h[6]==argc and old[h[2]][0][0]==callee and native==nrows
 arguments=args[h[5]:h[5]+argc];gone={call,h[2],*arguments};found=0
 for j in arguments:
  x=old[j][0];op=ops[x[1]]
  if op=='ARROW':
   assert ops[old[x[2]][0][1]]=='VALUE';gone.add(x[2]);found+=1
  else: assert op=='VALUE'
 assert found==members and not removed.intersection(gone)
 removed.update(gone);markers.add(root)
kept=[i for i in range(len(old)) if i not in removed]
assert len(kept)==len(new),(len(kept),len(new))
mapping=dict(zip(kept,range(len(kept))));stats=Counter();examples={}
for i,j in mapping.items():
 h,v,c=old[i];g,w,e=new[j];marker=i in markers
 def bad(reason,detail=None):
  stats['bad '+reason]+=1
  examples.setdefault(reason,(h[0],i,j,detail))
 if h[0]!=g[0] or (0 if marker else h[1])!=g[1]:bad('identity')
 if v!=w:bad('value',[k for k in range(len(v)) if v[k]!=w[k]])
 if h[7:]!=g[7:]:bad('diagnostics')
 if marker:continue
 for a,b in zip(h[2:5],g[2:5]):
  stats['edges']+=a!=none
  if (mapping.get(a,-1) if a!=none else none)!=b:bad('edge',(a,b))
 if c!=e:bad('conversion/member',[k for k in range(len(c)) if c[k]!=e[k]])
 if h[6]!=g[6]:bad('argument count')
 for a,b in zip(range(h[5],h[5]+h[6]),range(g[5],g[5]+g[6])):
  stats['arguments']+=1
  if mapping.get(args[a],-1)!=narg[b]:bad('argument edge')
  if aconv[a]!=nconv[b]:bad('argument conversion')
out=dict(extra_calls=len(extra),base_calls=len(base),members=sum(x[0] for x in extra.values()),native_entries=sum(x[1] for x in extra.values()),base_nodes=len(old),new_nodes=len(new),eliminated=len(removed),base_types=nt,new_types=newt,graph=dict(stats),first=examples)
for suffix in ['native','o','refs']:
 aa=(d/('base.'+suffix)).read_bytes();bb=(d/('arrow.'+suffix)).read_bytes()
 out[suffix]=dict(equal=aa==bb,base_hash=hashlib.sha256(aa).hexdigest(),candidate_hash=hashlib.sha256(bb).hexdigest(),base_bytes=len(aa),candidate_bytes=len(bb),first_byte=next((i for i,(a,b) in enumerate(zip(aa,bb)) if a!=b),None))
print(json.dumps(out,indent=2))
