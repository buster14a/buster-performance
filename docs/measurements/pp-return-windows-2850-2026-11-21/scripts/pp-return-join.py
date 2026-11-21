from pathlib import Path
import struct, re, sys, collections, csv
rows_path, take_path, out_path=map(Path,sys.argv[1:])
rows={t:(v,n) for t,v,n in struct.iter_unpack('<III',rows_path.read_bytes())}
take={};consumed=set()
for line in take_path.read_text().splitlines():
 m=re.fullmatch(r'compact-taken: token=(\d+) operand=(\d+) node=(\d+) removed=(\d+) rows=(\d+) whole=(\d+)',line)
 if m:
  t,operand,node,removed,entries,whole=map(int,m.groups());assert t not in take;take[t]=operand,node,removed,entries,whole
 m=re.fullmatch(r'compact-consumed: token=(\d+) node=(\d+)',line)
 if m:consumed.add(int(m[1]))
counts=collections.Counter()
with out_path.open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n')
 w.writerow(('return_pp','leaf_pp','payload','unresolved_name','native_root','native_operand','native_removed','native_rows','whole','lowered'))
 for t,(v,n) in rows.items():
  match=t in take and take[t][0]==t+1 and take[t][-1]
  lower=match and t in consumed
  counts[n,bool(match),bool(lower)]+=1
  op,node,rem,entries,whole=take[t] if t in take else (-1,-1,0,0,0)
  w.writerow((t,t+1,v,n,node,op,rem,entries,whole,int(bool(lower))))
print('native picked whole',sum(r[-1] for r in take.values()),'total',len(take),'consumed',len(consumed))
print('PP name/independent match/lowered -> count',counts)
print('eligible overlapping by position alone but not source operand',sum(t in take and (take[t][0]!=t+1 or not take[t][-1]) for t in rows))
