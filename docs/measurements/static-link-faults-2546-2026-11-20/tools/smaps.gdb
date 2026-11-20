set pagination off
set breakpoint pending on
break bind_end
run
python
import gdb
pid = gdb.selected_inferior().pid
open('/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546/smaps-before.txt','w').write(open('/proc/%d/smaps' % pid).read())
open('/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546/status-before.txt','w').write(open('/proc/%d/status' % pid).read())
end
finish
python
import gdb
pid = gdb.selected_inferior().pid
open('/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546/smaps-after.txt','w').write(open('/proc/%d/smaps' % pid).read())
open('/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546/status-after.txt','w').write(open('/proc/%d/status' % pid).read())
end
kill
quit
