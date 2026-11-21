set pagination off
set confirm off
set debuginfod enabled off
break c_check_common_warnings.c:10917
commands
silent
python
inf=gdb.selected_inferior()
n=int(gdb.parse_and_eval('graph->count'))
bits=bytes(inf.read_memory(int(gdb.parse_and_eval('root_bits')),((n+63)//64)*8))
marks=bytes(inf.read_memory(int(gdb.parse_and_eval('evaluated')),n))
roots=sum(x.bit_count() for x in bits)
clears=[i for i,v in enumerate(marks) if not v]
assert all((bits[i//8]>>(i%8))&1 for i in clears)
print("root-census nodes",n,"root-count",roots,"cleared",len(clears),"evaluated",roots-len(clears))
end
continue
end
run
