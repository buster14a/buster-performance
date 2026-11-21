set pagination off
set debuginfod enabled off
python
import gdb,re
from pathlib import Path
from collections import Counter
src=Path("src/buster/compiler/c_check_input.c").read_text()
options=src[src.index("typedef enum CheckInputExpressionCode"):src.index("} CheckInputExpressionCode;")]
names=[v for v in re.findall(r"^\s*CHECK_INPUT_CODE_([A-Z_]+),",options,re.M)]
ids={v:n for n,v in enumerate(names)}
print("action-codes",ids)
tally=Counter()
class Candidate(gdb.Breakpoint):
    def stop(self):
        act=int(gdb.parse_and_eval("$r8d"))
        addr=int(gdb.parse_and_eval("$rcx"))
        tokens=int(gdb.parse_and_eval("$rdx"))
        mat=bytes(gdb.selected_inferior().read_memory(addr,act*4))
        pos=bytes(gdb.selected_inferior().read_memory(tokens,act*4))
        words=[int.from_bytes(mat[i:i+4],"little")>>2&31 for i in range(0,len(mat),4)]
        sites=[int.from_bytes(pos[i:i+4],"little") for i in range(0,len(pos),4)]
        tally["chunks"]+=1
        tally["actions"]+=act
        tally["returns"]+=words.count(ids["RETURN"])
        tally["terminators"]+=words.count(ids["TERMINATOR"])
        for i in range(1,len(words)):
            if words[i-1:i+1] != [ids["BINARY"],ids["TERMINATOR"]]:continue
            tally["legacy"]+=1
            if i>=3 and words[i-3]==ids["IDENTIFIER"] and words[i-2] in (ids["IDENTIFIER"],ids["LITERAL"]):
                tally["full"]+=1
                if sites[i-3:i+1]==[sites[i]-3,sites[i]-1,sites[i]-2,sites[i]]:tally["full-token-order"]+=1
        return False
bp=Candidate("*check_input_window_actions",internal=True)
end
run
python print("scan-counts",tally)
