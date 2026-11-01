# static.awk -v list=FILE: in objdump -d --no-show-raw-insn's text, the instructions of the functions FILE names (a name
# a line), without the padding between functions (nops, int3, data16).
BEGIN { while ((getline line < list) > 0) want[line] = 1 }
/^[0-9a-f]+ <.*>:$/ { name = substr($2, 2, length($2) - 3); next }
/^ +[0-9a-f]+:\t/ {
    if (!(name in want)) next
    insn = $0
    sub(/^ +[0-9a-f]+:\t/, "", insn)
    if (insn ~ /^(nop|int3|data16|cs nop|ds nop|xchg +%ax,%ax)/) next
    count += 1
}
END { print count + 0 }
