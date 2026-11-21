from pathlib import Path
from collections import Counter
import struct
d=Path(__file__).resolve().parent
for name in ('sqlite','lua','musl'):
 data=list(struct.iter_unpack('<27I',(d/(name+'.bin')).read_bytes()))
 print(name,'modes',Counter(r[:2] for r in data))
 cases=[r for r in data if r[0]==1 and r[1]]
 print('left',Counter(((r[15]>>18)&1,r[8]&0x9f,bool(r[9]&0x80)) for r in cases).most_common(12))
 print('index',Counter((r[11],r[12]&0x9f) for r in cases).most_common(12))
 mask=0x03ff0000;want=0x03020000
 print('word vs row',sum(((r[14]&mask)==want)!=((r[21]&65537)==65537) for r in data),'all',len(data))
 print('left failures',Counter((r[7],r[8]&0x9f,r[9],r[11],r[12]&0x9f) for r in data if r[0]==1 and not r[1]).most_common(4))
