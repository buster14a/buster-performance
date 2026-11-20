from pathlib import Path
import csv,struct,sys
p=Path(__file__).resolve().parent;w=p.parent;sys.path.insert(0,str(w/'x87-pool-evidence'))
from elfcheck import Elf,write
r=[]
for f in sorted((w/'x87-pool-evidence/libm/out/candidate').glob('*.o')):
 e=Elf(f);pool=e.byname.get('.rodata.cst16')
 if not pool:continue
 used=[]
 for sec,pos,typ,tgt,add in e.relocs:
  if typ!=2 or add!=-4 or e.sections[tgt[2]]!=pool or e.bytes(e.sections[sec])[pos-2:pos]!=bytes([219,45]):continue
  low,high=struct.unpack_from('<QH',e.bytes(pool),tgt[3]);x=high&32767;fit=(16383-1022<=x<=16383+1023 and (low>>63)==1 and (low&2047)==0);used.append([low,high,fit])
 if used:r.append([f.name,len(used),len({(a,b) for a,b,_ in used}),sum(c for _,_,c in used),len({(a,b) for a,b,c in used if c})])
write(p/'census.tsv',['object','wide_load_relocations','unique_wide','double_exact_loads','unique_double_exact'],r)
print(len(r),'objects:',list(map(sum,zip(*[x[1:] for x in r]))))
