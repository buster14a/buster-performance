set pagination off
set confirm off
set debuginfod enabled off
break *check_common_ignored_prepare
commands
silent
up
python
import hashlib
inf=gdb.selected_inferior()
n=int(gdb.parse_and_eval("input->graph.count"))
p=int(gdb.parse_and_eval("emission.emitted"))
d=bytes(inf.read_memory(p,n))
print("literal-context",n,"marked",d.count(16),"zero",d.count(0),"sha256",hashlib.sha256(d).hexdigest())
assert d.count(16)+d.count(0)==n
end
continue
end
run
