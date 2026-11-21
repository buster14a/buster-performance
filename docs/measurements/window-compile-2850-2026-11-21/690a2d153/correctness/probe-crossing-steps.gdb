set pagination off
set debuginfod enabled off
python
import gdb, array, collections
wanted={560131,66561}
class Source(gdb.Breakpoint):
 def stop(self):
    mem=lambda p,n:bytes(gdb.selected_inferior().read_memory(p,n))
    val=lambda p,n:int.from_bytes(mem(p,n),'little')
    reg=lambda n:int(gdb.parse_and_eval('$'+n))
    r=reg('rdi');p=val(r+8,8)
    parent=val(p+168,8);roles=val(p+152,8);kinds=val(p+88,8)
    n=reg('r8d');t=reg('rdx');c=reg('rcx')
    ts=array.array('I',mem(t,n*4)); cs=array.array('I',mem(c,n*4))
    for i,tok in enumerate(ts):
        if tok in wanted or (tok+1) in wanted:
            start=max(0,i-4);end=min(n,i+5);pairs=[(u,(v>>2)&31) for u,v in zip(ts[start:end],cs[start:end])]
            print('INC',tok,'action',i,'of',n,'role',val(roles+tok,1),'kind',val(kinds+tok,1),'parent',val(parent+tok*4,4),pairs)
    return False
Source('*check_input_window_actions',internal=True)
end
run
