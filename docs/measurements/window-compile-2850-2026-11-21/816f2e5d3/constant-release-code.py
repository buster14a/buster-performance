"""Compare ELF load addresses and bytes for all executable sections and the relevant production functions."""
import csv,hashlib,struct,subprocess,sys
from pathlib import Path
files=list(map(Path,sys.argv[1:]))
w=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n')
w.writerow(['kind','name','reference-address','candidate-address','reference-bytes','candidate-bytes','reference-sha256','candidate-sha256','identical-layout-and-bytes'])
def parts(binary):
    blob=binary.read_bytes()
    h=struct.unpack_from('<16sHHIQQQIHHHHHH',blob)
    assert h[0][:6]==b'\x7fELF\x02\x01'
    shoff,ents,n,strings=h[6],h[11],h[12],h[13]
    fields=[struct.unpack_from('<IIQQQQIIQQ',blob,shoff+i*ents) for i in range(n)]
    strtable=blob[fields[strings][4]:fields[strings][4]+fields[strings][5]]
    secs={}
    for name,ty,flags,addr,offset,length,*other in fields:
        if flags&4:
            end=strtable.index(0,name);key=strtable[name:end].decode()
            secs[key]=(addr,blob[offset:offset+length])
    result={('section',k):v for k,v in secs.items()}
    targets={'check_input_expressions_coded_range','check_integer_window_actions','check_driver_command'}
    for line in subprocess.check_output(['nm','-Sn','--defined-only',str(binary)],text=True).splitlines():
        fs=line.split()
        if len(fs)!=4 or fs[3] not in targets:continue
        addr,size=int(fs[0],16),int(fs[1],16)
        eligible=[(v,p) for v,p in secs.values() if v<=addr and addr+size<=v+len(p)]
        assert len(eligible)==1
        taddr,tblob=eligible[0]
        data=tblob[addr-taddr:addr-taddr+size];assert len(data)==size
        result['function',fs[3]]=(addr,data)
    assert all(('function',x) in result for x in targets)
    result['file','ELF']=(0,blob)
    return result
a,b=map(parts,files)
assert set(a)==set(b)
for k in sorted(a):
    aa,ab=a[k];ba,bb=b[k]
    w.writerow([*k,hex(aa),hex(ba),len(ab),len(bb),hashlib.sha256(ab).hexdigest(),hashlib.sha256(bb).hexdigest(),int(aa==ba and ab==bb)])
