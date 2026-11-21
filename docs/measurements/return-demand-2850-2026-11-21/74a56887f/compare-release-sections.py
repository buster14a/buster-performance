"""Compare ELF64 section contents in the two unabridged native compiler images."""
from hashlib import sha256
from pathlib import Path
import struct,sys,csv

def sections(path):
    with Path(path).open('rb') as file:
        e=file.read(64)
        assert e[:6]==b'\x7fELF\x02\x01'
        shoff=struct.unpack_from('<Q',e,40)[0]
        entsize,total,strings=struct.unpack_from('<HHH',e,58)
        assert entsize==64 and total
        file.seek(shoff)
        headers=[struct.unpack('<IIQQQQIIQQ',file.read(64)) for _ in range(total)]
        p=headers[strings];file.seek(p[4]);names=file.read(p[5]);out={}
        for name,kind,flags,address,offset,size,*_ in headers:
            label=names[name:names.find(b'\0',name)].decode()
            if not label:continue
            file.seek(offset)
            # SHT_NOBITS holds reserved zero-fill and occupies no file bytes.
            out[label]=(kind,flags,address,size,sha256(file.read(size) if kind!=8 else b'').hexdigest())
        return out
a,b=map(sections,sys.argv[1:3]);w=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n')
w.writerow(['section','alloc','first-address','second-address','first-size','second-size','first-sha256','second-sha256','equal'])
for n in dict.fromkeys(list(a)+list(b)):
    x=a.get(n,(0,0,0,0,''));y=b.get(n,(0,0,0,0,''))
    w.writerow([n,int(bool((x[1]|y[1])&2)),hex(x[2]),hex(y[2]),x[3],y[3],x[4],y[4],int(x==y)])
