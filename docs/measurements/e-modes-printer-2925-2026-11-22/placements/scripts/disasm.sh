#!/bin/bash
# The hot functions' disassembly in two trees' Release executables (build/compiler), addresses and their branch
# targets' offsets normalized, and how many lines differ (#2925's default path against main's).
set -u
D=~/buster-fast-bench/1380-claude-2925
A=${1:?usage: disasm.sh TREE TREE FUNCTION...}
B=${2:?usage: disasm.sh TREE TREE FUNCTION...}
shift 2
mkdir -p $D/disasm
for f in "$@"; do
    for t in $A $B; do
        objdump -d --no-show-raw-insn --disassemble=$f $D/$t/build/compiler | sed -n '/^[0-9a-f]* <'$f'>:/,/^$/p' |
            sed -E 's/^ *[0-9a-f]+:\t//; s/\b[0-9a-f]{6,}\b/ADDR/g; s/<([A-Za-z_0-9.]+)\+0x[0-9a-f]+>/<\1+OFF>/g' > $D/disasm/$t.$f.s
    done
    printf '%s: %s %d lines, %s %d lines, %d differ\n' $f $A $(wc -l < $D/disasm/$A.$f.s) $B $(wc -l < $D/disasm/$B.$f.s) $(diff $D/disasm/$A.$f.s $D/disasm/$B.$f.s | grep -c '^[<>]')
done
