from pathlib import Path
import collections, sys, re, struct, json, gzip
d=Path(__file__).resolve().parent
raw=Path(sys.argv[1]).read_bytes()
n,narg,vs,cs=struct.unpack_from('<4I',raw)
stride=40+vs+cs+8
args=struct.unpack_from('<%dI'%narg,raw,16+n*stride)
src=(d.parent/'window-pure-interior/src/buster/compiler/c_check_actions.c').read_text()
ops=re.findall(r'^    CHECK_OP_([A-Z_]+),',src,flags=re.M)
children=[];parents=[[] for i in range(n)];quiet=[];stand=[];tok=[];op=[];spans=[]
for i in range(n):
 p=16+stride*i
 t,o,a,b,c,s,cnt,diag,w,ignored=struct.unpack_from('<10I',raw,p)
 ty,cat,fl,ck=struct.unpack_from('<4I',raw,p+40)
 fault,=struct.unpack_from('<I',raw,p+40+84)
 ch=[v for v in (a,b,c) if v!=2**32-1]+list(args[s:s+cnt])
 for v in ch:parents[v].append(i)
 children.append(ch);op.append(ops[o]);tok.append(t);stand.append((ty,cat,fl,ck));quiet.append(not (diag or w or fault))
modes={'arithmetic_int':set(ops[1:3]+ops[4:21]),'four_operators_int':set(['POSITIVE','NEGATIVE','ADD','SUBTRACT','MULTIPLY']), 'builtin_integer_wide':set(ops[1:21])}
for mode,active in modes.items():
 lens=[0]*n
 for i in range(n):
  o=op[i];ty,cat,fl,ck=stand[i];ch=children[i]
  ok=quiet[i] and cat==0 and ck==1 and (fl&~0x20001)==0 and fl&1 and (ty==64 if 'wide' not in mode else ty in range(16,113,8))
  if o=='VALUE' and ok:lens[i]=1
  elif o in active and ok and ch and all(lens[v] and len(parents[v])==1 for v in ch):lens[i]=1+sum(lens[v] for v in ch)
 tops=[i for i,x in enumerate(lens) if x>1 and not any(lens[p]>1 for p in parents[i])]
 parent=collections.Counter(op[p] if p<n else 'UNIT' for i in tops for p in (parents[i] or [n]))
 size=collections.Counter(lens[i] for i in tops)
 f=d/(mode+'.tsv.gz')
 with gzip.open(f,'wt') as out:
  print('token','node','op','count','parents',sep='\t',file=out)
  for i in tops:print(tok[i],i,op[i],lens[i],','.join(op[p] for p in parents[i]),sep='\t',file=out)
 print(mode,json.dumps(dict(root_count=len(tops),ordinary=n,rows_removed=sum(lens[i]-1 for i in tops),parent=parent,sizes=size)))
