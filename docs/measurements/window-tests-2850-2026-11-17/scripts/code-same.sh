#!/bin/bash
# code-same.sh A B FUNCTION...: each FUNCTION's machine code in results/A/compiler and results/B/compiler, with
# addresses taken out: its instruction count and size in each, where it starts in its 64-byte line and 4 KB page, and
# the count of disassembly lines that differ.
cd "$(dirname "$0")"
a=$1; b=$2; shift 2
for f in "$@"; do
    for l in "$a" "$b"; do
        objdump -d --no-show-raw-insn --disassemble=$f results/$l/compiler | grep -P '^\s+[0-9a-f]+:\t' | sed -E 's/^\s+[0-9a-f]+:\t//; s/[0-9a-f]{5,} <[^>]*>/ADDR/g; s/0x[0-9a-f]{5,}/ADDR/g; s/# [0-9a-f]+ <[^>]*>//' > /tmp/code-same-$l-$f.txt
        nm -S results/$l/compiler | grep -w "$f" | awk -v l=$l -v f=$f '{ a = strtonum("0x" $1); printf "%s %s: at %s (line offset %d, page offset %d) size %d\n", l, f, $1, a % 64, a % 4096, strtonum("0x" $2) }'
        echo "$l $f: $(wc -l < /tmp/code-same-$l-$f.txt) instructions"
    done
    echo "$f: lines that differ: $(diff /tmp/code-same-$a-$f.txt /tmp/code-same-$b-$f.txt | grep -c '^[<>]')"
done
