from pathlib import Path
import csv, collections, sys
d=Path(__file__).resolve().parent
r={int(row['pp-row']):row for row in csv.DictReader((d.parent/'pp-member-declaration-study/resolved.tsv').open(),delimiter='\t')}
with (d/'accepted.tsv').open('w') as o:
 out=csv.writer(o,delimiter='\t')
 out.writerow(['pp_row','function_close','record_reference','record_connected','name','declared_field_slot','offset_bits','parser_initial_name','final_name','chosen_declaration_name'])
 p=d/'sqlite.physical.chain.stderr'
 accepted=set();phys={};ids={};stats=collections.Counter()
 for line in p.open():
  v=line.split()
  if not v:continue
  if v[0]=='source-chain':
   _,base,last,dep,rows,node,t=v;stats['chains']+=1;stats['rows']+=int(rows)
   for i in range(int(dep)):accepted.add(int(base)+2+2*i)
  elif v[0]=='chain-spelling': phys[int(v[1])]=tuple(map(int,v[2:]))
  elif v[0]=='chain-identity': ids[int(v[1])]=tuple(map(int,v[2:]))
 for key in sorted(accepted):
  ref=r[key];sourced=(ref['source']=='True')
  stats['accepted hops']+=1
  assert (key in phys)==sourced, (key,sourced,phys.get(key))
  if not sourced:continue
  stats['physically sourced hops']+=1
  assert key in ids
  typ,slot,off=phys[key];old,new,field,decl=ids[key]
  assert new==decl and old==0 and slot==field==int(ref['member-slot']) and off==int(ref['offset-bits']), (key,ref,phys[key],ids[key])
  stats['different record ID']+=typ!=int(ref['record'])
  out.writerow([key,ref['close'],ref['record'],typ,ref['spelling'],slot,off,old,new,decl])
 print(dict(stats))
 print('physical preflight rows declined',len(phys.keys()-accepted))
