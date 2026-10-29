#!/bin/bash
# #847's E2: the instruction at each faulting IP of the binaries (non-PIE, so an IP is the file's address), one line
# each: TREE IP INSTRUCTION. Reads "TREE IP" lines on standard input. No lock: objdump reads the files only.
D=~/buster-fast-bench/claude-764
while read -r tree ip; do
    s=$((16#$ip))
    line=$(nice -n 19 objdump -d --no-show-raw-insn --start-address=$s --stop-address=$((s + 16)) "$D/trees/$tree/build/compiler" | grep -m1 -E "^ +[0-9a-f]+:")
    echo "$tree $ip ${line#*:}"
done
