#!/bin/bash
# shapes.sh LABEL: in each corpus's objects' code (the objects compile-all.sh left in /dev/shm/claude-2883-o-LABEL,
# listed by objects.sh), buster#2877's shape: a compare's value made and tested again before a branch (setCC %al;
# movzbl %al,%eax; test %eax,%eax; je or jne, where cmp; jCC would do), as the census's record counted it
# (tier0-census-2874-2026-11-16/scripts/shapes.sh, the same patterns). Beside it, a local read, changed in rax and
# written back (mov HOME,%eax; OP ...,%eax; mov %eax,HOME), a constant made and tested (xor %eax,%eax or mov $K,%eax;
# test %eax,%eax; je or jne), counted apart where a jmp is right before it (the arm of a && or a || that knows the
# answer: the other arm jumps over the constant to the test) and elsewhere (a condition the source spells as a
# constant, such as do {} while (0)), and the instructions and conditional branches. Every site of the first shape
# too: its object, function and address (results/LABEL/sites-CORPUS.txt). No lock: objdump on CPU 7 at niceness 19.
# results/LABEL/shapes.txt.
cd "$(dirname "$0")"
label=$1
for c in sqlite3 lua musl; do
    xargs -a scratch/objects-$label-$c.txt taskset -c 7 nice -n 19 objdump -d --no-show-raw-insn | awk -v corpus="$c" -v sites="results/$label/sites-$c.txt" '
        BEGIN { printf "" > sites }
        /file format/ { object = $1; sub(/:$/, "", object); sub(/.*\//, "", object) }
        /^ *[0-9a-f]+:\t/ {
            address = $1; sub(/:$/, "", address)
            line = $0; sub(/^ *[0-9a-f]+:\t/, "", line); gsub(/[ \t]+/, " ", line); sub(/ +$/, "", line)
            if (line ~ /^(int3|nop|cs nop|data16|xchg %ax,%ax)/) { next }
            total += 1
            a = b; b = c; c = d; d = line
            if (line ~ /^j[a-z]+ / && line !~ /^jmp /) { branches += 1 }
            if (a ~ /^set[a-z]+ %al$/ && b == "movzbl %al,%eax" && c == "test %eax,%eax" && d ~ /^j(e|ne) /) { tested += 1; print object, name, address, a >> sites }
            if ((b == "xor %eax,%eax" || b ~ /^mov \$0x[0-9a-f]+,%eax$/) && c == "test %eax,%eax" && d ~ /^j(e|ne) /) { constants += 1; if (a ~ /^jmp /) joined += 1 }
            if (b ~ /^mov [^,$]+(\([^)]*\))?,%[er]ax$/ && c ~ /^(add|sub|and|or|xor|imul|shl|shr|sar|inc|dec|neg|not) (.*,)?%[er]ax$/ && d ~ /^mov %[er]ax,/) {
                source = b; sub(/^mov /, "", source); sub(/,%[er]ax$/, "", source)
                target = d; sub(/^mov %[er]ax,/, "", target)
                if (source == target && source !~ /^%[er]ax$/) { if (source ~ /^%/) updated += 1; else updated_slots += 1 }
            }
        }
        /^[0-9a-f]+ <.*>:$/ { a = b = c = d = ""; name = $2; sub(/^</, "", name); sub(/>:$/, "", name) }
        END {
            printf "%s: %d instructions, %d conditional branches; %d compares tested again (%.1f%% of the branches; 3 instructions each more than cmp; jCC: %d, %.2f%% of the instructions); updated through rax %d registers and %d places of the frame (2 instructions each more: %d, %.2f%%); %d constants made and tested (3 instructions each: %d, %.2f%%), %d of them after a jmp\n",
                   corpus, total, branches, tested, 100 * tested / branches, 3 * tested, 300 * tested / total, updated, updated_slots, 2 * (updated + updated_slots), 200 * (updated + updated_slots) / total,
                   constants, 3 * constants, 300 * constants / total, joined
        }'
done | tee results/$label/shapes.txt
