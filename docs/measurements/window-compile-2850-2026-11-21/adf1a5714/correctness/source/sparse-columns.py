import subprocess,hashlib,struct
from pathlib import Path
import os
d=Path(__file__).resolve().parent;os.chdir(d)
p=Path('sparse-columns.c')
source=bytearray()
for begin in [0,1,63,64,127,128,191,255,256,319,383,447,448,509,510,511]:
 for n in [1,63,64,65,255,256,511,512,513,1024,2051]:
  for kind in ['name','string','number']:
   source.extend(b'\n'*(-len(source)%512));source.extend(b' '*begin)
   tok={'name':b'A'*n,'string':b'"'+b'B'*n+b'"','number':b'7'*n}[kind]
   source.extend(tok);source.extend(b'\n'+b' '*1024+b'\n')
p.write_bytes(source)
rows=[]
for tag,mode in [('parent-raw',1),('parent-raw',0),('lookahead-raw',0),('combined-bounds-raw',0)]:
 a=subprocess.check_output([str(d/tag/'columns'),str(mode),'28',str(p)])
 n=struct.unpack_from('<q',a)[0];assert n==16*11*3,n
 rows.append(hashlib.sha256(a).hexdigest());print(tag,mode,len(source),n,rows[-1])
assert len(set(rows))==1
