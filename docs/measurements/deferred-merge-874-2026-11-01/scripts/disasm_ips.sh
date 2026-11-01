#!/bin/bash
# #874 E2: the instruction at each faulting IP of the fix and control binaries (non-PIE), one line each:
# TREE IP INSTRUCTION. Reads "TREE IP" lines on standard input. No lock: objdump reads the files only.
D=/home/david/buster-fast-bench/874-verify
while read -r tree ip; do
    s=$((16#$ip))
    line=$(nice -n 19 objdump -d --no-show-raw-insn --start-address=$s --stop-address=$((s + 16)) "$D/trees/$tree/build/compiler" | grep -m1 -E "^ +[0-9a-f]+:")
    echo "$tree $ip ${line#*:}"
done
