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
        p=int(gdb.parse_and_eval('$rsi'))
        print('pending-coverage tokens=%d nodes=%d roots=%d rows=%d prior=%d' % (read(p,1924,4), read(p,236,4), read(p,2852,4), read(p,2840,4), read(p,2856,4)))
        return False
Capture('*check_graph_run')
end
run
