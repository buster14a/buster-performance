#!/bin/bash
# joins.sh OUT [CORPUS...]: in each corpus's objects (compile-all.sh's, in OUT), buster#2883's joins: a logical
# operator's value made 0 or 1 at a join and tested again (`test %eax,%eax; setne %al; movzbl %al,%eax; jmp; xor
# %eax,%eax` or `mov $K,%eax`, then `test %eax,%eax; je/jne`), seven instructions where its second operand's `test; jCC`
# is two, and those of them with `setCC %al; movzbl %al,%eax` before, nine where a compare's `jCC` is one. Also the
# constants made and tested (`xor %eax,%eax` or `mov $K,%eax`, then `test %eax,%eax; je/jne`), and those right after a
# `jmp`. No lock: objdump at niceness 19.
cd "$(dirname "$0")"
. ./corpora.sh
out=$1; shift
for c in "${@:-sqlite3 lua musl}"; do
    for name in $c; do
        corpus_files "$name" | sed 's|.*/||; s|\.c$|.o|' | sort -u | sed "s|^|$out/|" > "$out/objects-$name.txt"
        xargs -a "$out/objects-$name.txt" nice -n 19 objdump -d --no-show-raw-insn | awk -v corpus="$name" '
            /^ *[0-9a-f]+:\t/ {
                line = $0; sub(/^ *[0-9a-f]+:\t/, "", line); gsub(/[ \t]+/, " ", line); sub(/ +$/, "", line)
                if (line ~ /^(int3|nop|cs nop|data16|xchg %ax,%ax)/) { next }
                total += 1
                for (i = 1; i < 9; i += 1) { w[i] = w[i + 1] }
                w[9] = line
                constant = w[7] == "xor %eax,%eax" || w[7] ~ /^mov \$0x[0-9a-f]+,%eax$/
                if (constant && w[8] == "test %eax,%eax" && w[9] ~ /^j(e|ne) /) {
                    tested += 1
                    if (w[6] ~ /^jmp /) { after_jump += 1 }
                    if (w[3] == "test %eax,%eax" && w[4] == "setne %al" && w[5] == "movzbl %al,%eax" && w[6] ~ /^jmp /) {
                        joins += 1
                        if (w[1] ~ /^set[a-z]+ %al$/ && w[2] == "movzbl %al,%eax") { compares += 1 }
                    }
                }
            }
            /^[0-9a-f]+ <.*>:$/ { for (i = 1; i <= 9; i += 1) { w[i] = "" } }
            END {
                more = 8 * compares + 5 * (joins - compares)
                printf "%s: %d instructions; %d joins, %d of them of a compare; %d instructions more than the jumps (%.1f%%); constants made and tested %d, %d right after a jmp\n",
                       corpus, total, joins, compares, more, 100 * more / total, tested, after_jump
            }'
    done
done
