import re,subprocess,mmap,struct,collections
from pathlib import Path
def get(role):
 sections=[]
 for l in subprocess.check_output(['readelf','-SW','work/asm1313/'+role],text=True).splitlines():
  m=re.match(r'\s*\[\s*\d+\] (\S+)\s+(\S+)\s+([\da-f]+)\s+([\da-f]+)\s+([\da-f]+)',l)
  if m:
   n,t,a,o,s=m.groups();sections.append((int(a,16),int(a,16)+int(s,16),int(o,16),n,t))
 fp=open('work/asm1313/'+role,'rb'); image=mmap.mmap(fp.fileno(),0,access=mmap.ACCESS_READ)
 def fetch(a,n):
  for low,hi,off,name,t in sections:
   if low<=a<hi and t!='NOBITS':return image[off+a-low:off+min(hi-low,a-low+n)]
  return b''
 d={}
 for l in Path('work/asm1313/'+role+'.nm').read_text().splitlines():
  x=l.split()
  if len(x)==4 and x[2]=='d' and x[3].startswith('check_input_'):d[x[3]]=(int(x[0],16),int(x[1],16))
 return d,fetch
b,bf=get('only1530');h,hf=get('both');rows=[]
for name in sorted(b.keys()&h.keys()):
 ba,bs=b[name];ha,hs=h[name]
 if bs!=hs:continue
 data=bf(ba,bs);hd=hf(ha,hs)
 for i in range(0,len(data)-7,8):
  bp=int.from_bytes(data[i:i+8],'little');hp=int.from_bytes(hd[i:i+8],'little');
  if not(0x216800<=bp<0xa2c5a0 and 0x216800<=hp<0xa2d960 and ((bp&4095)>4032)!=((hp&4095)>4032)):continue
  s=bf(bp,120).split(b'\0',1)[0];t=hf(hp,120).split(b'\0',1)[0]
  if s==t and s and all(32<=x<127 for x in s):rows.append((name,i,bp,hp,s))
print('matching strings with changed strlen fast/slow path',len(rows))
for row in rows:print(row)
