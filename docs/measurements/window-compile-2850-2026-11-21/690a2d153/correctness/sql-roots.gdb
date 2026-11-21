set debuginfod enabled off
set pagination off
set inferior-tty /dev/null
python
import os,gdb,struct
from array import array
from pathlib import Path
class Roots(gdb.Breakpoint):
 def stop(self):
    inf=gdb.selected_inferior()
    mem=lambda a,n:bytes(inf.read_memory(a,n))
    val=lambda a,n:int.from_bytes(mem(a,n),'little')
    graph=int(gdb.parse_and_eval('$rdi'));stream=int(gdb.parse_and_eval('$rsi'))
    count=val(stream+0x120,4)
    ptr=lambda a,o:val(a+o,8)
    arr=lambda at,n:array('I',mem(at,n*4))
    ops=arr(ptr(graph,32),count);ts=arr(ptr(graph,40),count);ms=arr(ptr(graph,120),count)
    if os.environ['PROBE_SOURCE']=='window':
        candidates=[i for i in range(count) if ops[i]==0 and ms[i]!=0]
    else:
        candidates=[i for i in range(count) if ops[i] in (24,36,40,41)]
    keys=arr(ptr(stream,0x60),count) if ptr(stream,0x60) else [0]*count
    full=mem(ptr(stream,0x30),count*96) if ptr(stream,0x30) else b''
    sparse=mem(ptr(stream,0x68),val(stream+0x70,4)*96) if ptr(stream,0x68) else b''
    cols={delta:mem(ptr(stream,o),width*count) for o,delta,width in [(0x38,0,4),(0x50,4,1),(0x40,8,4),(0x58,12,1),(0x48,64,4)] if ptr(stream,o)}
    with open(os.environ['PROBE_ROOTS'],'wb') as f:
        for n in candidates:
            row=keys[n]
            if full: raw=full[96*n:96*(n+1)]
            elif row:raw=sparse[(row-1)*96:row*96]
            else:
                raw=bytearray(96)
                for dest,width in [(0,4),(4,1),(8,4),(12,1),(64,4)]:
                    if dest in cols:raw[dest:dest+width]=cols[dest][n*width:(n+1)*width]
            assert len(raw)==96
            f.write(struct.pack('<III',ts[n],ops[n],ms[n])+raw)
    print("snapshot",os.environ['PROBE_SOURCE'],count,len(candidates))
    return False
b=Roots('check_driver_dump',internal=True)
end
run
