from pathlib import Path
import csv,collections
d=Path(__file__).resolve().parent;input=d.parent/'member-chain-lowering-proof-study/sqlite.chain.stderr'
accepted={}
for s in input.read_text().splitlines():
 if s.startswith('source-chain'):
  _,base,last,depth,rows,node,t=s.split();base,last,depth=map(int,(base,last,depth))
  for i in range(depth):
   token=base+2+2*i;assert token not in accepted;accepted[token]=(base,last,depth,i+1)
credit=collections.Counter();regions=collections.Counter()
with (d/'joined.tsv').open('w') as o,(d.parent/'pp-member-declaration-study/resolved.tsv').open() as f:
 w=csv.writer(o,delimiter='\t');w.writerow('pp-row selected source-backed closing-token type member-slot offset-bits field-width quals base-use final-use chain-length rank'.split())
 for r in csv.DictReader(f,delimiter='\t'):
  pp=int(r['pp-row']);item=accepted.get(pp);source=r['source']=='True';bitfield=int(r['bit-width'])>0;quals=int(r['inherited-qualifiers'])
  credit['ordinary']+=1;credit['source-backed']+=source;credit['ordinary bitfield']+=bitfield;credit['ordinary inherited qualifier']+=bool(quals)
  if item:
   credit['owned']+=1;credit['owned source-backed']+=source;credit['owned bitfield']+=bitfield;credit['owned inherited qualifier']+=bool(quals);regions[r['close']]+=1
  w.writerow([pp,int(item is not None),int(source),r['close'],r['record'],r['member-slot'],r['offset-bits'],r['bit-width'],quals,*((0,0,0,0) if item is None else item)])
assert len(accepted)==credit['owned']
credit['functions with source operands']=len(regions);print(credit)
