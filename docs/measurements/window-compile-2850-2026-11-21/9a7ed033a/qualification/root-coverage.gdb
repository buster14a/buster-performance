set pagination off
set debuginfod enabled off
set confirm off
python
import gdb
def read(base,offset,size):
    return int.from_bytes(gdb.selected_inferior().read_memory(base+offset,size).tobytes(),'little')
def pop(base,n):
    return sum(b.bit_count() for b in gdb.selected_inferior().read_memory(base,(n+7)//8).tobytes()) if base else 0
class Capture(gdb.Breakpoint):
    def stop(self):
        p=int(gdb.parse_and_eval('$rsi')); n=read(p,244,4); t=read(p,1932,4)
        holder=read(p,0,8); bits=read(holder,48,8) if holder else 0; m=pop(bits,n)
        print('root-coverage tokens=%d checked_nodes=%d prepared=%d' % (t,n,m))
        return False
Capture('*check_graph_run')
end
run
