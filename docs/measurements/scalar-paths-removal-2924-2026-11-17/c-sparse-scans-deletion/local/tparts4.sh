#!/bin/bash
# The tests commit's tree (twins present): test-checker's and test-checker-driver's eight parts each, two at a time.
O=/root/.cache/claude-c7/c12k/tparts4
cd /home/user/buster-c12kt || exit 1
export PATH=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH
mkdir -p $O; : > $O/status.txt
for pair in "1 2" "3 4" "5 6" "7 8"; do
    for k in $pair; do nice -n 5 timeout -k 5 1800 ./build/compiler test-checker --seed 133 --part $k/8 > $O/checker-$k.log 2>&1 & done; wait
done
for pair in "1 2" "3 4" "5 6" "7 8"; do
    for k in $pair; do nice -n 5 timeout -k 5 2400 ./build/compiler test-checker-driver --executable ./build/compiler --part $k/8 --in-process > $O/driver-$k.log 2>&1 & done; wait
done
for f in $O/checker-*.log $O/driver-*.log; do echo "$(basename $f): $(grep -E 'checks, [0-9]+ failures' $f | tail -1)" >> $O/status.txt; done
echo done >> $O/status.txt
