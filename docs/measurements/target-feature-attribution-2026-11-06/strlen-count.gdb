set pagination off
set confirm off
set disable-randomization off
python
import gdb, collections, json
hits = collections.Counter()
class Slow(gdb.Breakpoint):
    def __init__(self):
        super().__init__('*(__strlen_evex512+0x140)', internal=True)
    def stop(self):
        try:
            ptr = int(gdb.parse_and_eval('$rdi'))
            name = gdb.Value(ptr).cast(gdb.lookup_type('char').pointer()).string(errors='replace')
            hits[(hex(ptr),name)] += 1
        except Exception as e:
            hits[('read-error',str(e))] += 1
        return False
Slow()
end
run
python
code=gdb.parse_and_eval('$_exitcode')
print('CODEX_EXIT_STATUS',code)
print('CODEX_STRLEN_COUNTS',json.dumps([{'address':a,'string':s,'count':n} for (a,s),n in hits.items()],sort_keys=True))
if int(code) != 0:
    gdb.execute('quit 1')
end
