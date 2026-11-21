import subprocess,hashlib,struct
from pathlib import Path
from time import monotonic
import os
d=Path(__file__).resolve().parent;os.chdir(d)
corpora=[('sqlite',list(Path('../switch-inputs/sqlite').glob('sqlite3.[ch]')),[28]),('lua',list(Path('../switch-inputs/inputs/lua-5.4.8/src').glob('*.[ch]')),[28]),('musl',list(Path('../switch-inputs/libc/musl/src').rglob('*.c')),[4]),('compiler',list(Path('../for-assignment/src/buster/compiler').rglob('*.[ch]')),[28]),('cxx',list(Path('../for-assignment/tools').rglob('*.cpp')),[2,6])]
for name,paths,flags in corpora:
 paths=sorted(paths)
 assert paths
 for flag in flags:
  source_bytes=sum(p.stat().st_size for p in paths)
  sha=[]
  for m,mode in [('parent-raw',1),('parent-raw',0),('lookahead-raw',0),('combined-bounds-raw',0)]:
   r=subprocess.run([str(d/m/'lex-corpus'),str(mode),str(flag),*paths],capture_output=True,check=True)
   sha.append(hashlib.sha256(r.stdout).hexdigest())
   at=0; count=0
   for f in paths:
    n=struct.unpack_from('<q',r.stdout,at)[0];assert n>=0,f
    at+=8+9*n;count+=n
   assert at==len(r.stdout)
   print(name,flag,m,mode,len(paths),source_bytes,count,at,sha[-1],flush=True)
  assert len(set(sha))==1,(name,flag)
