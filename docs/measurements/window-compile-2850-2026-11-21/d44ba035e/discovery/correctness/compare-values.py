from pathlib import Path
import collections,hashlib,struct,sys
s=Path(sys.argv[1])
def load(name):
 return list(struct.iter_unpack('<III96s',(s/f'values-{name}.bin').read_bytes()))
base=collections.defaultdict(list)
for token,op,index,payload in load('ordinary'): base[token].append((op,payload))
opcode=['<','<=','>','>=','==','!=']
taken={}
with (s/'values-summary.tsv').open('w') as out:
 print('mode\tall_saved_roots\tmatched_comparisons\tdiffering\tlt\tle\tgt\tge\teq\tne\tmatched_token_value_sha256',file=out)
 for mode in ('original','control','plain'):
  data=load(mode)
  hist=[0]*6; mismatches=0; token_values=[]
  for token,op,index,payload in data:
   if token in base:
    vals=base[token]
    assert len(vals)==1
    oper,expected=vals[0]
    hist[oper-12]+=1
    mismatches+=int(payload!=expected)
    token_values.append(struct.pack('<II',token,oper)+payload)
  taken[mode]=set(token_values)
  assert not mismatches,(mode,mismatches)
  assert sum(hist)==(1352 if mode=='plain' else 1367)
  print(mode,len(data),sum(hist),mismatches,*hist,hashlib.sha256(b''.join(sorted(token_values))).hexdigest(),file=out,sep='\t')
assert taken['original']==taken['control'] and taken['plain']<taken['control']
