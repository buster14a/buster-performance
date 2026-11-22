from pathlib import Path
import struct,json,re,csv
from collections import Counter
d=Path(__file__).resolve().parent;w=d.parent
opsnames=re.findall(r'^\s*(CHECK_OP_\w+),',(w/'body-action-transfers/src/buster/compiler/c_check_actions.c').read_text().split('typedef enum CheckOp')[1].split('}')[0],re.M)
inher=0x10|0x20000 # corrected below from actual declarations
defs=dict(re.findall(r'#define (BUSTER_CHECK_\w+) (0x[0-9a-fA-F]+)u',(w/'body-action-transfers/src/buster/compiler/c_check_actions.c').read_text()))
def flag(k):return int(defs['BUSTER_CHECK_'+k],16)
ordinary=flag('SIDE_EFFECT')|flag('MODIFICATION')
lvalue=ordinary|flag('NONNULL_ADDRESS')|flag('REGISTER')|flag('REGISTER_NAME')|flag('STATIC_OBJECT')
literal=flag('ICE')|flag('LITERAL_ZERO')
grow={}
for corp in ('sqlite','main'):
 p=w/'source-member-operands-study/capture'/(corp+'-prior')
 def col(k,ty='I'):return memoryview((p/k).read_bytes()).cast(ty)
 op=col('graph.ops');a=col('graph.operand0');b=col('graph.operand1');types=col('stream.value_types');flags=col('stream.value_flags');co=col('stream.value_constants','B');cat=col('stream.value_categories','B');pay=col('stream.payload_rows');raw=col('stream.payloads','B');ctx=col('stream.constant_evaluated','B') if (p/'stream.constant_evaluated').exists() else bytes(len(op))
 def kind(i):
  c=co[i];f=flags[i];z=pay[i]
  if cat[i]==0 and c==1 and not (f&~literal) and (not z or int.from_bytes(raw[(z-1)*96+84:(z-1)*96+88],'little')==0):return 2
  if z==0 and ((cat[i]==0 and c==0 and not(f&~ordinary)) or (cat[i]==1 and c in (0,3) and not(f&~lvalue))):return 1
  return 0
 dims=Counter();families=Counter()
 for i,o in enumerate(op):
  if o not in (5,6,7,12,13,14,15,16,17,18,19,20):continue
  dims['arithmetic']+=1;l=a[i];r=b[i]
  if max(l,r)>=i or ctx[i]:continue
  x,y=kind(l),kind(r)
  if not x or not y or x+y==4:continue
  dims['unknown-eligible']+=1
  if not (16<=types[l]<=104 and 16<=types[r]<=104 and not ((types[l]|types[r])&7)): continue
  dims['all-builtin-integers']+=1
  if types[l]!=types[r] or types[l]<64:continue
  dims['same-unconverted']+=1
  start=i//16*16
  ready=all(j<start or op[j]==0 for j in (l,r))
  if ready:dims['initial-independent']+=1;families[opsnames[o]]+=1
 print(corp,len(op),dict(dims),families,flush=True);grow[corp]={'graph':len(op),'counts':dims,'operators':families}
(d/'prior-census.json').write_text(json.dumps(grow,indent=2))
