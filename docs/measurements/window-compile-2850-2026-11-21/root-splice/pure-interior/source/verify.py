from pathlib import Path
import struct,re,collections,sys,json
d=Path(sys.argv[1]);none=(1<<32)-1;h=struct.Struct('<10I')
def load(k):
 r=(d/(k+'.bin')).read_bytes();n,a,vs,cs=struct.unpack_from('<4I',r);w=40+vs+cs+8
 return [(h.unpack_from(r,p),r[p+40:p+40+vs],r[p+40+vs:p+w]) for i in range(n) if (p:=16+w*i)],struct.unpack_from('<%dI'%a,r,16+w*n)
ref,args=load('plain');new,nargs=load('source')
def links(head,arg):return [x for x in head[2:5] if x!=none]+list(arg[head[5]:head[5]+head[6]])
by=collections.defaultdict(list)
for n,(row,_,_) in enumerate(ref):by[row[0]].append(n)
records=[tuple(map(int,m)) for m in re.findall(r'interior-taken: token=(\d+) node=(\d+) removed=(\d+) op=(\d+) parent=(\d+)',(d/'source.err').read_text())]
gone=set();sums={};parents=collections.Counter()
for tok,n,count,_,_ in records:
 matches=[v for v in by[tok] if ref[v][0][1] in range(1,21)]
 assert len(matches)==1,(tok,matches)
 old,=matches; work=links(ref[old][0],args); local=set()
 while work:
  v=work.pop();assert v not in local;local.add(v);work+=links(ref[v][0],args)
 assert len(local)==count and gone.isdisjoint(local),(tok,len(local),count)
 gone.update(local);sums[old]=n
kept=[v for v in range(len(ref)) if v not in gone]; assert len(kept)==len(new),(len(kept),len(new)); mapping={v:n for n,v in enumerate(kept)}
bad=collections.Counter();first={};edges=0
for n,v in enumerate(kept):
 (a,x,y),(b,z,w)=ref[v],new[n];collapsed=v in sums
 tests={'token':a[0]==b[0],'value':x==z,'warnings_diagnostics':a[7:]==b[7:], 'op':b[1]==(0 if collapsed else a[1])}
 if collapsed:tests['leaf']=n==sums[v] and not links(b,nargs)
 else:
  os=links(a,args);edges+=len(os);tests['edges']=[mapping.get(t) for t in os]==links(b,nargs);tests['conversion']=y==w
  if any(t in sums for t in os):parents[a[1]]+=1
 for k,ok in tests.items():
  if not ok:bad[k]+=1;first.setdefault(k,[v,n,a,b,[j for j in range(96) if x[j]!=z[j]]])
print(json.dumps(dict(ordinary=len(ref),retained=len(kept),removed=len(gone),source_roots=len(sums),ordinary_edges=edges,ordinary_parents=parents,mismatches=bad,first=first),indent=2))
