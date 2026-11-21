set debuginfod enabled off
set pagination off
set inferior-tty /dev/null
python
import os,gdb,hashlib,struct
from pathlib import Path
def word(a,n):return int.from_bytes(gdb.selected_inferior().read_memory(a,n),'little')
def reg(n):return int(gdb.parse_and_eval('$'+n))
def addr(s):return int(gdb.parse_and_eval("&'"+s+"'"))
class Open(gdb.Breakpoint):
 def stop(self):
    gdb.execute('set $r8d = '+str(4 if os.environ['NATIVE_MODE']=='on' else 0));return False
class Done(gdb.FinishBreakpoint):
 def __init__(self,out):
    super().__init__(gdb.newest_frame(),internal=True);self.out=out;self.silent=True
 def stop(self):
    s=self.out;count=word(s+820,4);func=word(s,8);ts=word(s+800,8);read=gdb.selected_inferior().read_memory
    assert gdb.parse_and_eval('$al')!=0 and count and ts
    last=0
    with open(os.environ['NATIVE_PROBE'],'w') as output:
        for i in range(count):
            f=func+i*392;n=word(f+24,4);last+=n
            digest=hashlib.sha256()
            for p,w in [(word(f,8),1),(word(f+8,8),1),(word(f+16,8),8),(word(ts+8*i,8),4)]:
                if n:digest.update(bytes(read(p,n*w)))
            print(i,n,digest.hexdigest(),file=output)
    print('native-source-roots',count,last)
    gdb.execute('set confirm off')
    gdb.execute('quit')
    return False
class Call(gdb.Breakpoint):
 def stop(self):
    r=reg('rdi');i=word(reg('rsi'),8)
    print("native-sourced-admissions",word(i+2860,4),word(i+2864,4),flush=True)
    Done(r)
    gdb.execute('set $rdx = 1');gdb.execute('set $pc = '+str(addr('check_program_lower_sources.buster_split')));return False
a=Open('*'+str(addr('lower_source_open.buster_split')),internal=True)
b=Call('*'+str(addr('check_program_lower_owners.buster_split')),internal=True)
end
run
