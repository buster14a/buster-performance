from pathlib import Path
import struct,re,collections,json,sys
d=Path(__file__).resolve().parent;rev=sys.argv[1];pol='sqlite-plain';p=d/rev/pol;r=(p/'plain.bin').read_bytes();n,ar,vs,cs=struct.unpack_from('<4I',r);width=40+vs+cs+8;a=struct.unpack_from('<%dI'%ar,r,16+n*width)
heads=[struct.unpack_from('<10I',r,16+width*i) for i in range(n)]
tokens=collections.defaultdict(list)
for i,h in enumerate(heads):tokens[h[0]].append(i)
def children(i):
 h=heads[i];return [x for x in h[2:5] if x!=2**32-1]+list(a[h[5]:h[5]+h[6]])
def tree(i):
 found={i};stack=[i]
 while stack:
  for k in children(stack.pop()):
   if k not in found:found.add(k);stack.append(k)
 return found
prior=set();full=set();oldroots=set();base=d.parent/'lean-source-study/bb86d4685/source.err'
for line in base.read_text().splitlines():
 if line.startswith('compact-taken:'):
  t,operand,new,size,rows,whole=map(int,re.findall(r'=([0-9]+)',line));wrapper,=[v for v in tokens[t] if children(v) and heads[children(v)[0]][0]==operand];old=children(wrapper)[0]
  subtree=tree(old);prior|=subtree if whole else subtree-{old};full|=subtree|{wrapper};oldroots.add(old)
pure=set();pts=set();pr={}
for line in (p/'source.err').read_text().splitlines():
 if line.startswith('interior-taken:'):
  t,new,size,op,parent=map(int,re.findall(r'=([0-9]+)',line));root,=[v for v in tokens[t] if heads[v][1] in range(1,21)];subtree=tree(root);pure|=subtree-{root};pts.add(root);pr[root]=subtree-{root}
print(json.dumps(dict(previous_removed=len(prior),interior_roots=len(pts),interior_removed=len(pure),roots_within_existing_spans=len(pts&full),interior_rows_already_removed=len(pure&prior),distinct_extra_removed=len(pure-prior),combined_ceiling=len(prior|pure),extra_roots_outside_previous=len(pts-full)),indent=2))
