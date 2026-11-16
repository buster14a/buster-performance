#!/bin/bash
# codediff.sh BASE HEAD: the functions whose code differs between results/BASE/compiler and results/HEAD/compiler, with
# the addresses left out: each function's disassembly without its instructions' own addresses, the targets' addresses
# (the names and offsets stay: "call <name>", "jmp <name+0x34>"), the displacements from rip and their comments, the
# immediates of six hexadecimal digits or more (an address in a static executable) and the padding (nop, int3), a line
# an instruction as NAME, its number in the function and its text, sorted. The names with a line in one executable
# alone are printed with those lines' count. One hold of the lock: two objdumps. results/HEAD/codediff.txt.
set -u
cd "$(dirname "$0")"
code()
{
    objdump -d --no-show-raw-insn "$1" | awk '
        /^[0-9a-f]+ <.*>:$/ { name = $2; gsub(/[<>:]/, "", name); number = 0; next }
        /^ *[0-9a-f]+:\t/ {
            line = $0
            sub(/^ *[0-9a-f]+:\t/, "", line)
            sub(/ *#.*$/, "", line)
            if (line ~ /^(nop|cs nop|data16|int3|xchg +%ax,%ax)/) { next }
            gsub(/[0-9a-f]+ </, "<", line)
            gsub(/-?0x[0-9a-f]+\(%rip\)/, "X(%rip)", line)
            gsub(/\$0x[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]+/, "$A", line)
            number += 1
            printf "%s\t%07d\t%s\n", name, number, line
        }' | LC_ALL=C sort
}
./lock.sh bash -c "$(declare -f code); code results/$1/compiler > scratch/code-$1.txt; code results/$2/compiler > scratch/code-$2.txt"
{
    echo "instructions (padding left out): $(wc -l < scratch/code-$1.txt) in $1, $(wc -l < scratch/code-$2.txt) in $2; functions with a line in one alone, and those lines' count in $1 and in $2:"
    diff scratch/code-$1.txt scratch/code-$2.txt | awk -F'\t' '/^[<>]/ { name = substr($1, 3); if (substr($1, 1, 1) == "<") base[name] += 1; else head[name] += 1; seen[name] = 1 } END { for (name in seen) print name, base[name] + 0, head[name] + 0 }' | LC_ALL=C sort
} > "results/$2/codediff.txt"
wc -l < "results/$2/codediff.txt"
