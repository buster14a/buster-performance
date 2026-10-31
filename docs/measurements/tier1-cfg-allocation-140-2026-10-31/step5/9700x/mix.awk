# The instruction mix of the functions `classes` (TAB name TAB tier) marks tier1, from objdump -d's text.
FILENAME == ARGV[1] { if ($2 == "tier1") take[$1] = 1; next }
/^[0-9a-f]+ <[^>]+>:$/ { name = substr($2, 2, length($2) - 3); inside = (name in take); next }
inside && NF >= 2 {
    line = $0; sub(/^ *[0-9a-f]+:\t/, "", line)
    split(line, f, /[ \t]+/); m = f[1]; ops = substr(line, length(m) + 2)
    if (m == "int3" || m == "nop") next
    total += 1
    if (ops ~ /\(%rsp\)/ || ops ~ /\(%rbp\)/) frame += 1
    if (m ~ /^set/) setcc += 1
    if ((m == "movzbl" || m == "movzwl") && ops ~ /^%[a-z0-9]+,%[a-z0-9]+$/) zext += 1
    if (m == "mov" && ops ~ /^%[a-z0-9]+,%[a-z0-9]+$/) { split(ops, r, ","); if (r[1] == r[2]) self += 1; else moves += 1 }
    if (m == "mov" && ops ~ /^\$/) constants += 1
    if (m == "test") tests += 1
    if (m == "div" || m == "idiv") divs += 1
    if (m == "call") calls += 1
    if (m == "push" || m == "pop") pushpop += 1
}
END { printf "instructions %d frame %d (%.1f%%) setcc %d zext %d moves %d self-moves %d constants %d tests %d divs %d calls %d push/pop %d\n", total, frame, 100.0 * frame / total, setcc, zext, moves, self, constants, tests, divs, calls, pushpop }
