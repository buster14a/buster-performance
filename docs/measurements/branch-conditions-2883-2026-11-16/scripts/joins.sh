#!/bin/bash
# joins.sh LABEL: in each corpus's objects' code, a && or a || used as a condition: its second operand made a value
# (test %eax,%eax; setne %al; movzbl %al,%eax), a jmp over the other arm's constant (xor %eax,%eax or mov $K,%eax), and
# the test of the joined value (test %eax,%eax; je or jne): seven instructions where the second operand's test and jump
# are two; and those of them whose second operand is a compare, whose value is made first (setCC %al; movzbl %al,%eax:
# nine instructions after the cmp where its jCC is one). No lock: objdump on CPU 7 at niceness 19.
# results/LABEL/joins.txt.
cd "$(dirname "$0")"
label=$1
for c in sqlite3 lua musl; do
    xargs -a scratch/objects-$label-$c.txt taskset -c 7 nice -n 19 objdump -d --no-show-raw-insn | awk -v corpus="$c" '
        /^ *[0-9a-f]+:\t/ {
            line = $0; sub(/^ *[0-9a-f]+:\t/, "", line); gsub(/[ \t]+/, " ", line); sub(/ +$/, "", line)
            if (line ~ /^(int3|nop|cs nop|data16|xchg %ax,%ax)/) { next }
            total += 1
            for (k = 1; k < 9; k += 1) w[k] = w[k + 1]
            w[9] = line
            join = w[3] == "test %eax,%eax" && w[4] == "setne %al" && w[5] == "movzbl %al,%eax" && w[6] ~ /^jmp / && (w[7] == "xor %eax,%eax" || w[7] ~ /^mov \$0x[0-9a-f]+,%eax$/) && w[8] == "test %eax,%eax" && w[9] ~ /^j(e|ne) /
            if (join) { joins += 1; if (w[1] ~ /^set[a-z]+ %al$/ && w[2] == "movzbl %al,%eax") compares += 1 }
        }
        /^[0-9a-f]+ <.*>:$/ { for (k = 1; k <= 9; k += 1) w[k] = "" }
        END { printf "%s: %d instructions; %d joins of a value made, a constant and their test (7 instructions where test; jCC is 2); %d of them of a compare (9 where jCC is 1); %d instructions more than the jumps, %.2f%%\n",
                     corpus, total, joins, compares, 5 * joins + 3 * compares, 100 * (5 * joins + 3 * compares) / total }'
done | tee results/$label/joins.txt
