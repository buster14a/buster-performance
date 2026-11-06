import re,subprocess,mmap
from pathlib import Path
def table(role):
 sections=[]
 for l in subprocess.check_output(['readelf','-SW','work/asm1313/'+role],text=True).splitlines():
  m=re.match(r'\s*\[\s*\d+\] (\S+)\s+(\S+)\s+([\da-f]+)\s+([\da-f]+)\s+([\da-f]+)',l)
  if m:
   _,t,a,o,s=m.groups();sections.append((int(a,16),int(a,16)+int(s,16),int(o,16),t))
 f=open('work/asm1313/'+role,'rb'); mm=mmap.mmap(f.fileno(),0,access=mmap.ACCESS_READ)
 def fetch(a,n):
  for low,hi,off,t in sections:
   if low<=a<hi and t!='NOBITS':return mm[off+a-low:off+min(a-low+n,hi-low)]
  return b''
 for l in Path('work/asm1313/'+role+'.nm').read_text().splitlines():
  x=l.split()
  if len(x)==4 and x[3]=='check_input_attribute_rules': addr=int(x[0],16);size=int(x[1],16);break
 else:raise Exception('no table')
 blob=fetch(addr,size);out=[]
 for off in range(0,size,24):
  ptr=int.from_bytes(blob[off:off+8],'little');out.append((fetch(ptr,160).split(b'\0',1)[0].decode(),ptr))
 return out
roles=['base','head','hybrid','padded'];ts=[table(r) for r in roles]
assert all([x[0] for x in t]==[x[0] for x in ts[0]] for t in ts)
print('index name base head hybrid padded: hex page offsets, ! means > 0xfc0')
for i,items in enumerate(zip(*ts)):
 p=[x[1]&4095 for x in items]
 if len(set(v>4032 for v in p))>1:
  print(i,items[0][0],*[f'{v:03x}'+('!' if v>4032 else '') for v in p])
print('slow path rule names each variant')
for role,t in zip(roles,ts):print(role,[(n,hex(v&4095)) for n,v in t if (v&4095)>4032])
