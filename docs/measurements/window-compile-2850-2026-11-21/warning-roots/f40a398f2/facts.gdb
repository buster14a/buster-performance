set pagination off
set debuginfod enabled off
set confirm off
break *check_common_graph_warnings
commands
silent
python
import hashlib
inf=gdb.selected_inferior()
def rd(p,n):
    return bytes(inf.read_memory(p,n))
def word(p):
    return int.from_bytes(rd(p,8),'little')
f=word(int(gdb.parse_and_eval('$rsp'))+8)
cand=word(f+16)
n=int.from_bytes(rd(cand+8,4),'little')
blocks=int.from_bytes(rd(cand+12,4),'little')
assert (n+15)//16==blocks and n<100000000,(n,blocks)
indices=rd(word(f+8),((n+63)//64)*8) if word(f+8) else b''
evaluation=rd(word(f+32),n)
assert all(v in (0,1) for v in evaluation)
print("facts nodes",n,"roots",sum(x.bit_count() for x in indices),"cleared-nodes",evaluation.count(0),"sha256",hashlib.sha256(evaluation).hexdigest())
end
continue
end
run
