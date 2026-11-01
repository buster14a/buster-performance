# count.awk: in objdump -d --no-show-raw-insn's text, the instructions, the zero extensions of a register that the
# narrow load before them filled, the frame objects' leas, the setcc's and the divisions.
/^[0-9a-f]+ <.*>:$/ { prev = ""; next }
/^ +[0-9a-f]+:/ {
    sub(/^ +[0-9a-f]+:\t/, "")
    ins = $0
    n += 1
    if (ins ~ /^movz[bw]l %[a-z0-9]+,%[a-z0-9]+$/ && prev ~ /^movz[bw]l .*\(.*\),%/) { split(ins, a, ","); split(prev, b, ","); if (a[2] == b[2]) redundant += 1 }
    if (ins ~ /^lea +-?0x[0-9a-f]+\(%rsp\),%/ || ins ~ /^lea +\(%rsp\),%/) stack_lea += 1
    if (ins ~ /^set/) setcc += 1
    if (ins ~ /^i?div/) div += 1
    prev = ins
}
END { printf "instructions %d, zero extensions after a narrow load %d, frame objects' leas %d, setcc %d, divisions %d\n", n, redundant, stack_lea, setcc, div }
