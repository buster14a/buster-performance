#!/usr/bin/env bash
# static.sh NAME...: records.sh's objects of each build (rep/sq-NAME.o and rep/lua-NAME/*.o) by objdump: .text bytes,
# instructions (objdump's lines with an address), and add and mov with a memory source operand (AT&T: a parenthesized
# first operand).
set -eu
R=/root/.cache/claude-2602/rep
for t in "$@"; do
    for w in sq lua; do
        if [ $w = sq ]; then objects=$R/sq-$t.o; else objects=$(ls $R/lua-$t/*.o); fi
        text=0; for o in $objects; do s=$(size -A $o | awk '$1 == ".text" { print $2 }'); text=$((text + ${s:-0})); done
        objdump -d --no-show-raw-insn $objects > $R/$w-$t.dis
        instructions=$(grep -cE "^ +[0-9a-f]+:" $R/$w-$t.dis)
        adds=$(grep -cE "^ +[0-9a-f]+:\s+add[lq]?\s+[^,]*\(" $R/$w-$t.dis || true)
        movs=$(grep -cE "^ +[0-9a-f]+:\s+mov[lq]?\s+[^,]*\(" $R/$w-$t.dis || true)
        echo "$w $t text=$text instructions=$instructions add_from_memory=$adds mov_from_memory=$movs objects_sha256=$(cat $objects | sha256sum | cut -c1-64)"
    done
done
