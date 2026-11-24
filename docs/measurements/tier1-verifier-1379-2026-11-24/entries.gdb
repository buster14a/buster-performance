set pagination off
set confirm off
set debuginfod enabled off
set breakpoint pending off
set disable-randomization off
python
import gdb, collections
counts=collections.Counter()
class Count(gdb.Breakpoint):
    def stop(self):
        f=gdb.newest_frame()
        names=[]
        while f and len(names)<14:
            n=f.name()
            if n:
                names.append(n.split('.buster_split')[0])
            f=f.older()
        counts[tuple(names[:8])]+=1
        return False
import subprocess
names={'ir_check_rows','ir_check_dominance','ir_cfg_validated'}
symbols=subprocess.check_output(['nm','-n','--defined-only',gdb.current_progspace().filename],text=True)
addresses=set()
for line in symbols.splitlines():
    fields=line.split()
    if len(fields)==3 and fields[2].split('.buster_split')[0] in names:
        addresses.add(int(fields[0],16))
for address in sorted(addresses):
    Count('*'+hex(address),internal=True)
end
run
python
for key,n in sorted(counts.items(), key=lambda kv:-kv[1]):
    print('%5d %s'%(n, ' <- '.join(key)))
end
