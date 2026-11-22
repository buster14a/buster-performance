set pagination off
set confirm off
set debuginfod enabled off
python
import gdb
from collections import Counter
stats=Counter()
def mem(addr,n): return gdb.selected_inferior().read_memory(addr,n).tobytes()
def read(base,off,n): return int.from_bytes(base[off:off+n],'little')
class End(gdb.FinishBreakpoint):
 def __init__(self,frame,runptr,first,end):
  super().__init__(frame,internal=True);self.runptr=runptr;self.first=first;self.end=end
 def stop(self):
  r=mem(self.runptr,128); csize=#CODE_SIZE#; bsize=#BODY_SIZE#; start=self.first; n=self.end-start
  codes=mem(read(r,#CODES#,8)+start*csize,n*csize); bodies=mem(read(r,#BODIES#,8)+start*bsize,n*bsize)
  combined=0;maxone=0
  for i in range(n):
   c=codes[i*csize:]; b=bodies[i*bsize:]; resolved=read(b,#FIELDS#,1); count=read(c,#CT#,4); refs=read(c,#REF_CT#,4)
   if not resolved:continue
   assert not read(c,#RECORD#,8) and not read(b,#ENDS#,8)
   combined+=count*16;maxone=max(maxone,count*16)
   stats['resolved_bodies']+=1;stats['resolved_fields']+=refs;stats['records_in_resolved_bodies']+=count
   if read(c,32,4)==0:
    stats['straight_bodies']+=1;stats['sizing_records_eliminated']+=count
   stats['removed_marked_record_bytes']+=refs*16
   stats['removed_fixup_end_bytes']+=(refs+16)*4
  stats['parts']+=1;stats['slots']+=n
  stats['max_window_excess_records_bytes']=max(stats['max_window_excess_records_bytes'],combined-maxone)
  return False
class Start(gdb.Breakpoint):
 def stop(self):
  if int(gdb.parse_and_eval('$rcx')) & ((1<<64)-1) == (1<<64)-1:return False
  part=mem(int(gdb.parse_and_eval('$rdx')),8)
  End(gdb.newest_frame(),int(gdb.parse_and_eval('$rdi')),read(part,0,4),read(part,4,4))
  return False
Start('*check_program_emit_code_half')
end
run
python
print('BODY FIELD COUNTS',dict(stats))
end
