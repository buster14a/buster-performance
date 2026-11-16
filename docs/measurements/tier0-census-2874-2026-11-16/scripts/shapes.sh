#!/bin/bash
# shapes.sh: in each corpus's objects' code (the objects compile-all.sh left in /dev/shm/claude-2874-o, listed by
# objects.sh), the instruction sequences Tier 0 writes where a fusion would write fewer: a compare's value made and
# tested again before a branch (setCC %al; movzbl %al,%eax; test %eax,%eax; je or jne, where cmp; jCC would do), and a
# local read, changed in rax and written back (mov HOME,%eax; OP ...,%eax; mov %eax,HOME, HOME a register or a place of
# the frame, in 32 and 64 bits, where OP ...,HOME would do). A by-product of the census: its keys show the first as a
# branch's group whose entries before are CONST 0 and NE after a compare. No lock: objdump on CPU 7 at niceness 19.
# results/main/shapes.txt.
cd "$(dirname "$0")"
for c in sqlite3 lua musl; do
    xargs -a scratch/objects-$c.txt taskset -c 7 nice -n 19 objdump -d --no-show-raw-insn | awk -v corpus="$c" '
        /^ *[0-9a-f]+:\t/ {
            line = $0; sub(/^ *[0-9a-f]+:\t/, "", line); gsub(/[ \t]+/, " ", line); sub(/ +$/, "", line)
            if (line ~ /^(int3|nop|cs nop|data16|xchg %ax,%ax)/) { next }
            total += 1
            a = b; b = c; c = d; d = line
            if (line ~ /^j[a-z]+ / && line !~ /^jmp /) { branches += 1 }
            if (a ~ /^set[a-z]+ %al$/ && b == "movzbl %al,%eax" && c == "test %eax,%eax" && d ~ /^j(e|ne) /) { tested += 1 }
            if (b ~ /^mov [^,$]+(\([^)]*\))?,%[er]ax$/ && c ~ /^(add|sub|and|or|xor|imul|shl|shr|sar|inc|dec|neg|not) (.*,)?%[er]ax$/ && d ~ /^mov %[er]ax,/) {
                source = b; sub(/^mov /, "", source); sub(/,%[er]ax$/, "", source)
                target = d; sub(/^mov %[er]ax,/, "", target)
                if (source == target && source !~ /^%[er]ax$/) { if (source ~ /^%/) updated += 1; else updated_slots += 1 }
            }
        }
        /^[0-9a-f]+ <.*>:$/ { a = b = c = d = "" }
        END {
            printf "%s: %d instructions, %d conditional branches; %d compares tested again (%.1f%% of the branches; 3 instructions each more than cmp; jCC: %d, %.2f%% of the instructions); updated through rax %d registers and %d places of the frame (2 instructions each more than one: %d, %.2f%%)\n",
                   corpus, total, branches, tested, 100 * tested / branches, 3 * tested, 300 * tested / total, updated, updated_slots, 2 * (updated + updated_slots), 200 * (updated + updated_slots) / total
        }'
done | tee results/main/shapes.txt
