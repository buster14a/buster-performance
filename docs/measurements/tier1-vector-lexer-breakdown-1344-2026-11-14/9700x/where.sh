#!/usr/bin/env bash
D=$HOME/buster-fast-bench/1344-claude
cd $D || exit 1
R=$(ls -d rows/measure-tier1-rows-* | head -1)
for o in lanes-0-15.o $R/lexer-base.o $R/lexer-tier1.o; do
    echo "== $o: memmove relocations $(objdump -dr $o | grep -c 'R_X86_64_PLT32.*memmove')"
    nm -n $o | grep -i ' t ' > syms.txt
    objdump -dr --no-show-raw-insn $o | awk '/^[0-9a-f]+ <tokenize_c>:/ {on=1; next} /^[0-9a-f]+ <.*>:$/ {on=0} on && /R_X86_64_PLT32/ {print $3}' | sort | uniq -c | sort -rn | while read n t; do
        case $t in
            .text+*) a=$(( ${t#.text+} + 4 )); s=$(awk -v a=$a 'BEGIN {best=""} {v=strtonum("0x"$1); if (v<=a) {best=$3; bv=v}} END {printf "%s+0x%x", best, a-bv}' syms.txt); echo "  $n $s";;
            *) echo "  $n $t";;
        esac
    done
done
ls $R | grep lexer | tr '\n' ' '
