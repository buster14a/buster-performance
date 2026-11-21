from collections import defaultdict,Counter
from pathlib import Path
import struct, hashlib,re,sys,json
d=Path(__file__).resolve().parent
H=struct.Struct('<IIII')
def read(name):
 raw=name.read_bytes(); keys=defaultdict(list); i=0
 while i<len(raw):
  token,op,argc,pad=H.unpack_from(raw,i); assert not pad
  n=96+32+8+argc*8
  beg=i+16;end=beg+n;assert end<=len(raw)
  keys[(token,op)].append(raw[beg:end if op==34 else beg+136]);i=end
 return keys
def compare(a,b):
 same=changes=drop=added=duplicates=0;ex=[]
 for key in a.keys()|b.keys():
  aa=a.get(key,[]);bb=b.get(key,[])
  if len(aa)!=len(bb):
   drop+=max(len(aa)-len(bb),0);added+=max(len(bb)-len(aa),0)
   if aa and bb:duplicates+=1
   continue
  for i,(x,y) in enumerate(zip(aa,bb)):
   if x==y:same+=1
   else:
    changes+=1
    if len(ex)<8:ex.append([*key,i,[(j,xx,yy) for j,(xx,yy) in enumerate(zip(x,y)) if xx!=yy][:4]])
 return dict(equal=same,changed=changes,removed=drop,added=added,partially_matched_keys=duplicates,examples=ex)
def section(p):
 src=p.read_text().splitlines()
 return [s for s in src if s.startswith('type ')],[s for s in src if s.startswith('new ')],[s for s in src if s.startswith('site ')]
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
report=[]
for p in sorted(d.glob('*-baseline.trace')):
 g=p.stem[:-9]
 if not (d/f'{g}-replay.bin').exists() or not (d/f'{g}-calls.bin').exists():continue
 b=read(d/(g+'-baseline.bin')); t0,e0,_=section(p)
 for mode in ['calls','replay']:
  head=d/f'{g}-{mode}';t,e,sites=section(head.with_suffix('.trace'));v=read(head.with_suffix('.bin'));diff=compare(b,v)
  first=next((i for i,(a,c) in enumerate(zip(t0,t)) if a!=c),None)
  outcome=dict(group=g,mode=mode,status=int(head.with_suffix('.status').read_text()),elf_same=sha(head.with_suffix('.o'))==sha(d/(g+'-baseline.o')),
               sites=len(sites),existing=sum(not l.endswith('pointer=0') for l in sites),types0=len(t0),types=len(t),new0=len(e0),new=len(e),table_identical=(t0==t),first_type_diff=first,
               **diff)
  print(g,mode,'calls',len(sites),'types',len(t0),len(t),'type_equal',t==t0,'unchanged',diff['equal'],'changed',diff['changed'],'uniqueRemoved/Added',diff['removed'],diff['added'],'elf',outcome['elf_same'])
  report.append(outcome)
(d/'results.json').write_text(json.dumps(report,indent=1)+'\n')
