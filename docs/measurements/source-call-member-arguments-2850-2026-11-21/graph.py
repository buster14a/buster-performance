from pathlib import Path
from collections import defaultdict,Counter
import struct,re,sys,json
none=2**32-1
def load(name):
 data=Path(name).read_bytes();n,argc,vs,cs,ac,nt=struct.unpack_from('<6I',data)
 stride=40+vs+cs+8
 def row(i):
  at=24+i*stride;return struct.unpack_from('<10I',data,at),data[at+40:at+40+vs],data[at+40+vs:at+stride]
 pos=24+n*stride;args=struct.unpack_from(f'<{argc}I',data,pos);pos+=4*argc
 cv=[data[pos+ac*i:pos+ac*(i+1)] for i in range(argc)]
 assert len(data)==pos+ac*argc
 return [row(i) for i in range(n)],args,cv,nt
