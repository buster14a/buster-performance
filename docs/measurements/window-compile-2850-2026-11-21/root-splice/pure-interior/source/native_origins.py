from pathlib import Path
import re,struct,collections,sys,csv,json,gzip
d=Path(__file__).resolve().parent;rev=sys.argv[1];p=d/rev/'sqlite-debug';data=(p/'source.native').read_bytes();g=(p/'source.bin').read_bytes();n,argc,vs,cs=struct.unpack_from('<4I',g);stride=40+vs+cs+8
roots={}
for l in (p/'source.err').read_text().splitlines():
 if l.startswith('interior-taken:'):
  token,new,count,op,parent=map(int,re.findall(r'=([0-9]+)',l));value=struct.unpack_from('<I',g,16+new*stride+40+16)[0];roots[token]=(new,value,count)
assert data==(p/'plain.native').read_bytes();pos=0;tagged=collections.defaultdict(list);entries=0
while pos<len(data):
 body,n,slots,calls,args,has=struct.unpack_from('<6I',data,pos);pos+=24
 k=data[pos:pos+n];pos+=n;c=data[pos:pos+n];pos+=n;v=struct.unpack_from('<%dQ'%n,data,pos);pos+=8*n
 if has:
  ss=struct.unpack_from('<%dI'%n,data,pos);pos+=4*n
  for i,token in enumerate(ss):
   if token in roots:tagged[token].append((i,body,k[i],c[i],v[i]));entries+=1
 pos+=slots*2+calls*13+args
with gzip.open(d/rev/'native-root-origins.tsv.gz','wt') as f:
 print('source_root','graph_node','checked_int','removed','body','index','kind','class','native_value',sep='\t',file=f)
 for t,(gn,value,rm) in roots.items():
  matches=tagged.get(t,[])
  if not matches:print(t,gn,value,rm,'','','','','',sep='\t',file=f)
  for n,b,k,c,v in matches: print(t,gn,value,rm,b,n,k,c,v,sep='\t',file=f)
const={t for t,rs in tagged.items() if any(x[2]==1 for x in rs)};bits={t for t,rs in tagged.items() if any(x[2]==1 and (x[4]&0xffffffff)==roots[t][1] for x in rs)}
print(json.dumps(dict(graph_sources=len(roots),distinct_native_origins=len(tagged),entries_tagged=entries,const_origins=len(const),same_low_32_const=len(bits),other_or_absorbed=len(roots)-len(tagged)),indent=2))
