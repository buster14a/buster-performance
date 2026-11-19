#!/bin/bash
# #2924 C10 (abed7371d) under MSan and ASan: the encoder's and its callers' tests, and the C driver's -c (Tier 0) and
# --tier1 on c-testsuite's first 30 programs. One heavy build at a time.
cd /home/user/buster-c10-tests || exit 1
git log --oneline -1 > ~/.cache/claude-c7/sanitizers-c10.head
log=~/.cache/claude-c7/sanitizers-c10.log
rm -f $log ~/.cache/claude-c7/c10-*-compiles.log
ct=$(cat ~/.cache/claude-c7/ct30.txt)
for s in memory address; do
    BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=$s nice -n 10 ./build.sh --config Release > ~/.cache/claude-c7/build-c10-$s.log 2>&1 || { echo "$s build failed" >> $log; continue; }
    exe=/home/user/buster-c10-tests/build/cmake/vector-$s-O3/Release/compiler
    for t in "test-x86-encoder" "test-branch-sizing" "test-assembler" "test-x86-semantics" "test-x86-target-selection" "test-unwind" "test-tier0-variadic-frame" \
             "test-tier1-emit" "test-tier1-pipeline" "test-tier1-masks" "test-builtin-atomic-helpers" "test-builtin-math-helpers" "test-builtin-terminal-helpers" \
             "test-checker-asm"; do
        n=$(echo "$t" | tr ' ' _)
        BUSTER_COMPILER=$exe timeout 3000 $exe $t > ~/.cache/claude-c7/c10-$s-$n.log 2>&1; echo "$s $t: $?" >> $log
    done
    for mode in tier0 tier1; do
        if [ $mode = tier0 ]; then opt=(); else opt=(--tier1); fi
        failed=0
        for f in $ct; do
            timeout 600 $exe -c "${opt[@]}" --lanes 1 "$f" -o /dev/shm/claude-2924-c10-san.o >> ~/.cache/claude-c7/c10-$s-compiles.log 2>&1 || { failed=$((failed+1)); echo "failed: $f" >> ~/.cache/claude-c7/c10-$s-compiles.log; }
        done
        echo "$s -c $mode of c-testsuite 30: $failed failed" >> $log
    done
    rm -f /dev/shm/claude-2924-c10-san.o
    grep -l "Sanitizer\|runtime error" ~/.cache/claude-c7/c10-$s-*.log >> $log 2>/dev/null
    rm -rf /home/user/buster-c10-tests/build/cmake/vector-$s-O3
done
echo done >> $log
