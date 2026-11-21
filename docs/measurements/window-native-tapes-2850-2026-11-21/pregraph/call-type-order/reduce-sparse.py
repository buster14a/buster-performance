from collections import Counter
from pathlib import Path
import json
d=Path(__file__).resolve().parent
exec((d/'reduce.py').read_text().split('report=[]')[0],globals())
import sys
prefix=sys.argv[1] if len(sys.argv)>1 else 'sparse'
rows=[]
for p in sorted(d.glob(prefix+'-*-baseline.trace')):
 stem=p.stem.removesuffix('-baseline')
 if stem.split('-')[-1] not in {'scalar','regions','levels','transitions'}: continue
 ref=d/(stem+'-baseline');new=d/(stem+'-replay')
 if not new.with_suffix('.status').exists():continue
 def stats(v):return int(v.with_suffix('.status').read_text()),v.with_suffix('.err').read_bytes(),v.with_suffix('.out').read_bytes()
 a,b=stats(ref),stats(new)
 if a[0] or b[0]:
  print(stem,'status',a[0],b[0],a[1][-60:],b[1][-60:]);continue
 t0=section(ref.with_suffix('.trace'))[0];t=section(new.with_suffix('.trace'))[0]
 diff=compare(read(ref.with_suffix('.bin')),read(new.with_suffix('.bin')))
 result=dict(case=stem,table_identical=t0==t,elf_same=sha(ref.with_suffix('.o'))==sha(new.with_suffix('.o')),messages_same=a==b,**diff)
 rows.append(result);print(stem,'table',len(t0),len(t),t0==t,'checked',diff['equal'],diff['changed'],'ELF',result['elf_same'])
(d/(prefix+'-results.json')).write_text(json.dumps(rows,indent=1)+'\n')
