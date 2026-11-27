from pathlib import Path
from struct import unpack_from
from hashlib import sha256
def sections(file):
 b=Path(file).read_bytes()
 shoff=unpack_from('<Q',b,40)[0];stride,total,names=unpack_from('<HHH',b,58)
 rows=[unpack_from('<IIQQQQIIQQ',b,shoff+i*stride) for i in range(total)]
 strtab=b[rows[names][4]:][:rows[names][5]]
 return {strtab[r[0]:].split(b'\0')[0].decode():(bool(r[2]&2),r[5],sha256(b[r[4]:r[4]+r[5]] if r[1]!=8 else b'').hexdigest()) for r in rows}
a,b=map(sections,['base','fresh'])
for k in sorted(a):
 if k in ('.text','.rodata','.data','.bss') or a[k]!=b.get(k): print(k,*a[k],*(b.get(k) or ()))
