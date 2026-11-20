from pathlib import Path
import hashlib,struct
p=Path(__file__).resolve().parent
for big in [False,True]:
 for n in [64,1024,4096]:
  endian='>' if big else '<';pack=lambda form,*vals:struct.pack(endian+form,*vals)
  low=[(i*2654435761+0x1000001)&0x7fffffff for i in range(n)];high=[0xffffffff-x//2 for x in low];refs=[(0,1),(0xffffffff,3),(1,1),(0x80000001,7),(2,1),(0xfffffffd,11)]
  tags=[(256,4,[1]),(257,4,[1]),(258,3,[32]),(259,3,[1]),(262,3,[1]),(273,4,[0]),(277,3,[n]),(278,4,[1]),(279,4,[4*n]),(284,3,[1]),(338,3,[0]*(n-1)),(339,3,[1]),(340,4,low),(341,4,high),(532,5,refs)]
  extra=bytearray();offset=8+2+12*len(tags)+4;items=[]
  for tag,typ,vals in tags:
   b=b''.join(pack({3:'H',4:'I',5:'II'}[typ],*(x if isinstance(x,tuple) else (x,))) for x in vals)
   if len(b)>4:v=pack('I',offset+len(extra));extra+=b;extra+=b'\0'*(len(extra)%2)
   else:v=b.ljust(4,b'\0')
   items.append([tag,typ,len(vals),v])
  pixel=offset+len(extra);next(x for x in items if x[0]==273)[3]=pack('I',pixel);out=(b'MM' if big else b'II')+pack('HI',42,8)+pack('H',len(items))+b''.join(pack('HHI',*x[:3])+x[3] for x in items)+pack('I',0)+extra+b'\0'*(4*n)
  (p/f'{"be" if big else "le"}-{n}.tif').write_bytes(out)
