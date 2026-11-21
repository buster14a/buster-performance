set pagination off
set debuginfod enabled off
set confirm off
python
import gdb
class Capture(gdb.Breakpoint):
    def stop(self):
        graph=int(gdb.parse_and_eval('$rsi'))
        read=gdb.selected_inferior().read_memory
        values=[int.from_bytes(read(graph+offset,4).tobytes(),'little') for offset in [1940, 252, 260, 88]]
        print('physical-leaves tokens=%d nodes=%d leaves=%d extended=%d' % tuple(values))
        return False
Capture('*check_graph_run')
end
run
