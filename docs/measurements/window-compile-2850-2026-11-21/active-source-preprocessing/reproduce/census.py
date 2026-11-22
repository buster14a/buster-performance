from array import array
from collections import Counter
from bisect import bisect_left
from pathlib import Path
import json,re,sys

d=Path(__file__).resolve().parent
src=(d.parent/'switch-inputs/sqlite/sqlite3.c').read_bytes()
target=Path(sys.argv[1]) if len(sys.argv)>1 else d
raw=(target/'primary.raw').read_bytes()
out=(target/'output.rows').read_bytes()
stats=(target/('census.err' if (target/'census.err').exists() else 'local-census.err')).read_text()
k=int(re.search(r'idkind (\d+)',stats)[1]);base=int(re.search(r'base (\d+)',stats)[1])
def u32(data):
 a=array('I');a.frombytes(data);return a
n=len(raw)//9;m=len(out)//10
rkind=raw[:n];starts=u32(raw[n:5*n]);values=u32(raw[5*n:])
okind=out[:m];flags=out[m:2*m];loc=u32(out[2*m:6*m]);oval=u32(out[6*m:])
primary_direct={p-base for p,f in zip(loc,flags) if base<=p<base+len(src) and not f&8}
active=[i for i,s in enumerate(starts) if s in primary_direct]
raw_ids=[v for c,v in zip(rkind,values) if c&127==k]
act_ids=[values[i] for i in active if rkind[i]&127==k]
freq=Counter(act_ids)
linebreaks=[m.start() for m in re.finditer(b'\n',src)]
lineforms=Counter();linetokens=Counter();shape=Counter();shapetokens=Counter();shapedelta=Counter()
cur=[];old=-1
def process(line,inds):
 if len(inds)<1:return
 a=linebreaks[line-1]+1 if line else 0;b=linebreaks[line] if line<len(linebreaks) else len(src)
 text=src[a:b]
 lineforms[text]+=1;linetokens[text]+=len(inds)
 # Kind, position, and exact identifier spelling. Reusable physical token rows without interning.
 key=tuple((rkind[i]&127,starts[i]-a,values[i] if rkind[i]&127==k else values[i]-a) for i in inds)
 shape[key]+=1;shapetokens[key]+=len(inds)
for i in active:
 line=bisect_left(linebreaks,starts[i])
 if line!=old:
  process(old,cur);cur=[];old=line
 cur.append(i)
process(old,cur)
widths=(4,8,16,32,64)
def blocks(width):
 seen=set();seen_kind=set();reused=shape_reuse=total=0
 for p in range(0,len(active)-width+1,width):
  ids=active[p:p+width]
  if ids[-1]-ids[0]!=width-1: continue
  total+=width
  key=tuple((rkind[i]&127,values[i] if rkind[i]&127==k else values[i]-starts[i]) for i in ids)
  phys=tuple((t, starts[i]-starts[ids[0]]) for t,i in zip(key,ids))
  if phys in seen:reused+=width
  if key in seen_kind:shape_reuse+=width
  seen.add(phys);seen_kind.add(key)
 return [total,reused,shape_reuse]
def reuse_size(counts,rows):
 return sum(rows[k]-rows[k]//v for k,v in counts.items() if v>1)
print(json.dumps({'eager_raw_tokens':n,'raw_identifiers':len(raw_ids),'raw_distinct_ids':len(set(raw_ids)),'output_tokens':m,
 'active_direct_primary_raw_tokens':len(active),'active_direct_primary_ids':len(act_ids),'distinct_active_ids':len(freq),
 'ranked_id_occurrences':{k:sum(v for _,v in freq.most_common(k)) for k in [16,64,256,1024,4096]},
 'primary_raw_row_bytes':n*9+(n+7)//8,'output_column_bytes':m*10,'direct_primary_output_column_bytes':len(active)*10,
 'physical_lines_with_direct_rows':sum(lineforms.values()),'distinct_exact_active_lines':len(lineforms),
 'tokens_in_repeated_exact_lines_after_first':reuse_size(lineforms,linetokens),'tokens_in_repeated_position_id_shapes_after_first':reuse_size(shape,shapetokens),
 'fresh_disjoint_token_tuples_total_exact_layout_kind_id':{k:blocks(k) for k in widths}},indent=2))
