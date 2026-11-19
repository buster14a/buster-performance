#!/bin/bash
# #2924 C11a (22f3d4625) under MSan and ASan: the assembler's tests (its digest), the matcher's semantics and inline
# assembly's tests, from the repository root.
cd /home/user/buster-c11 || exit 1
log=~/.cache/claude-c7/sanitizers-c11.log
rm -f $log
for s in memory address; do
    BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=$s nice -n 10 ./build.sh --config Release > ~/.cache/claude-c7/build-c11-$s.log 2>&1 || { echo "$s build failed" >> $log; continue; }
    exe=/home/user/buster-c11/build/cmake/vector-$s-O3/Release/compiler
    for t in "test-assembler" "test-assembler --seed 7" "test-x86-semantics" "test-checker-asm"; do
        n=$(echo "$t" | tr ' ' _)
        timeout 3000 $exe $t > ~/.cache/claude-c7/c11-$s-$n.log 2>&1; echo "$s $t: $?" >> $log
    done
    grep -l "Sanitizer\|runtime error" ~/.cache/claude-c7/c11-$s-*.log >> $log 2>/dev/null
    rm -rf /home/user/buster-c11/build/cmake/vector-$s-O3
done
echo done >> $log
