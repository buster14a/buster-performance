#!/bin/bash
# #2924 C10c (c98e08a5a) under MSan and ASan: test-x86-encoder in every mode (each entry point now its own reference).
cd /home/user/buster-c10c || exit 1
log=~/.cache/claude-c7/sanitizers-c10c.log
rm -f $log
for s in memory address; do
    BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=$s nice -n 10 ./build.sh --config Release > ~/.cache/claude-c7/build-c10c-$s.log 2>&1 || { echo "$s build failed" >> $log; continue; }
    exe=/home/user/buster-c10c/build/cmake/vector-$s-O3/Release/compiler
    for t in "test-x86-encoder" "test-x86-encoder --seed 7" "test-assembler" "test-branch-sizing"; do
        n=$(echo "$t" | tr ' ' _)
        timeout 3000 $exe $t > ~/.cache/claude-c7/c10c-$s-$n.log 2>&1; echo "$s $t: $?" >> $log
    done
    grep -l "Sanitizer\|runtime error" ~/.cache/claude-c7/c10c-$s-*.log >> $log 2>/dev/null
    rm -rf /home/user/buster-c10c/build/cmake/vector-$s-O3
done
echo done >> $log
