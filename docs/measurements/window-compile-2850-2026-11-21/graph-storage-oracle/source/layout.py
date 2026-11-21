from pathlib import Path
from array import array
from collections import Counter
import struct,sys,json,hashlib
path=Path(sys.argv[1]); out=Path(sys.argv[2]); data=path.read_bytes()
sig,tokens,count,cap,leaves,leafrest,arguments,payloads,groups,leafsize,fullsize,convsize,reportsize=struct.unpack_from('<13I',data)
assert sig==0x42575043
m=memoryview(data)
A=memoryview(data)[52:52+56*count].cast('I')
pos=52+56*count
args=m[pos:pos+4*arguments].cast('I');pos+=4*arguments
parts=[]
for _ in range(groups):
 length,=struct.unpack_from('<I',data,pos);pos+=4
 part=tuple(m[pos:pos+4*length].cast('I'));pos+=4*length
 assert len(part)>=2 and all(i<count for i in part) and len(set(part))==len(part)
 parts.append(part)
assert pos==len(data)
absent=(1<<32)-1
def row(i):return A[i*14:(i+1)*14]
def refs(i):
 d=row(i)
 return [x for x in (*d[2:5],*(args[d[7]:d[7]+d[8]] if d[9] else ())) if x!=absent]
owner=[-1]*count; hidden=[False]*count; declined=set(); overlaps=set()
for g,p in enumerate(parts):
 for i in p[:-1]:
  if owner[i]!=-1:overlaps.update((g,owner[i]))
  owner[i]=g
 for i in p[:-2]:hidden[i]=True
incoming=set();outgoing=set()
for i in range(count):
 for to in refs(i):
  assert to<i
  if owner[i]!=owner[to]:
   if hidden[to]:incoming.add(owner[to])
   if owner[i]!=-1:outgoing.add(owner[i])
declined=overlaps|incoming|outgoing
selected={g for g,p in enumerate(parts) if g not in declined and len(p)>2}
removed={n for g in selected for n in parts[g][:-2]}
new_roots={parts[g][-2] for g in selected}
wrappers={parts[g][-1] for g in selected}
assert not (new_roots&removed)
kept=[n for n in range(count) if n not in removed]; index=[absent]*count
for new,old in enumerate(kept):index[old]=new
edges=0; checksum=hashlib.sha256()
for old in kept:
 if old in new_roots:continue
 to=refs(old)
 for t in to:assert index[t]!=absent and index[t]<index[old] and kept[index[t]]==t
 edges+=len(to);checksum.update(struct.pack('<II',old,row(old)[0]));checksum.update(b''.join(struct.pack('<I',t) for t in to))
def sum_cols(nodes,field):return sum(bool(row(i)[field]) for i in nodes)
def args_of(nodes):return sum(row(i)[8] for i in nodes if row(i)[9])
assert sum(1 for i in range(count) if row(i)[1]==0)==leaves
assert sum_cols((i for i in range(count) if row(i)[1]==0),6)==leafrest
assert sum_cols(range(count),10)==payloads
cut_leaves=sum(row(i)[1]==0 for i in removed)
removed_payloads=sum_cols(removed,10); added_leaves=sum(row(i)[1]!=0 for i in new_roots)
added_rest=sum(row(i)[1]!=0 and row(i)[11] for i in new_roots)
cut_rest=sum(row(i)[1]==0 and bool(row(i)[6]) for i in removed)
cut_args=args_of(removed|new_roots)
observed={
 'actual':{'nodes':count,'leaves':leaves,'leaf_payloads':leafrest,'arguments':arguments,'stream_payloads':payloads},
 'projected':{'nodes':len(kept),'leaves':leaves-cut_leaves+added_leaves,'leaf_payloads':leafrest-cut_rest+added_rest,'arguments':arguments-cut_args,'stream_payloads':payloads-removed_payloads},
 'token_count':tokens,'ordinary_capacity':cap,'blind_groups':groups,'blind_records':sum(len(p) for p in parts),'overlapping_groups':len(overlaps),'incoming_interior_groups':len(incoming),'outgoing_from_window_groups':len(outgoing),'declined_in_union':len(declined),'positive_groups':len(selected),'distinct_ordinary_wrappers':len(wrappers),'removed_nodes':len(removed),'remapped_ordinary_edges':edges,'surviving_original_edge_token_digest':checksum.hexdigest(),'leaf_bytes':leafsize,'full_value_bytes':fullsize,'conversion_bytes':convsize,'report_bytes':reportsize,'removed_token_warnings':sum_cols(removed,12),'removed_node_diagnostics':sum_cols(removed,13)}
t=path.parent/'sqlite-ordinary-full.tsv'
typed=[x.split('\t') for x in t.read_text().splitlines()]
for group in ('graph','stream'):
 dst={}
 for variant,stats in [(k,observed[k]) for k in ('actual','projected')]:
  vals={}
  key={'leaf_records':'leaves','leaf_payloads':'leaf_payloads','argument_nodes':'arguments','argument_tokens':'arguments','payloads':'stream_payloads'}
  for stage,gr,name,capacity,used,stride,*_ in typed:
   if stage=='typed' and gr==group:
    n=stats[key.get(name,'nodes')] if name!='reports' else int(used)
    vals[name]=n*int(stride)
  dst[variant]=vals
 observed[group+'_logical_bytes']={s:sum(cols.values()) for s,cols in dst.items()}
 for k in dst['actual']:
  if k in dst['projected']:pass
out.write_text(json.dumps(observed,indent=2)+'\n')
print(json.dumps(observed,indent=2))
