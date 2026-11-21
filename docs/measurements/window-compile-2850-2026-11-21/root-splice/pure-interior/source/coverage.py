from pathlib import Path
import csv,gzip,collections,re,struct,json,sys
d=Path(__file__).resolve().parent;rev=sys.argv[1]
p=d/rev/'sqlite-plain';r=(p/'plain.bin').read_bytes();n,na,vs,cs=struct.unpack_from('<4I',r);stride=40+vs+cs+8;args=struct.unpack_from('<%dI'%na,r,16+n*stride)
h=[struct.unpack_from('<10I',r,16+i*stride) for i in range(n)];toks=collections.defaultdict(list)
for i,row in enumerate(h):toks[row[0]].append(i)
def subtree(i):
 out=set();walk=[i]
 while walk:
  k=walk.pop()
  if k not in out:
   out.add(k);row=h[k];walk.extend(c for c in row[2:5] if c<n);walk.extend(args[row[5]:row[5]+row[6]])
 return out
olds=set();exact=0;eligible=0;ambiguous=0
qual=d.parent/'pregraph-access-study/entry/sqlite-manifest.tsv.gz'
for v in csv.DictReader(gzip.open(qual,'rt'),delimiter='\t'):
 token,op,count=map(int,(v['token'],v['root-op'],v['records']));candidates=[i for i in toks[token] if h[i][1]==op];eligible+=1
 if len(candidates)==1:
  tree=subtree(candidates[0])
  if len(tree)==count: olds.update(tree);exact+=1
  else:ambiguous+=1
 else:ambiguous+=1
root_in=rows_in=root_out=rows_out=0
for line in (p/'source.err').read_text().splitlines():
 if line.startswith('interior-taken:'):
  t,new,size,op,parent=map(int,re.findall(r'=([0-9]+)',line));root,=[v for v in toks[t] if h[v][1] in range(1,21)];tr=subtree(root)-{root}
  if root in olds:root_in+=1
  else:root_out+=1
  rows_in+=len(tr&olds);rows_out+=len(tr-olds)
print(json.dumps(dict(proof_windows=eligible,exact_span=exact,uncertified=ambiguous,union_ordinary_rows=len(olds),pure_roots_within=root_in,pure_roots_outside=root_out,removed_nodes_within=rows_in,removed_nodes_outside=rows_out),indent=2))
