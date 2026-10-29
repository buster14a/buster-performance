#!/bin/bash
# The receipt, the builds, the head's test-x86-zen5, its measure-x86-zen5 of inc, dec, add and sub with an imm8 (their
# six experiments and the branch one), three processes each in a hold of its own, and -c of sqlite3.c by both trees,
# whose objects must be the same bytes (Tier 0's inc and dec unchanged).
cd "$(dirname "$0")" || exit 1
. ./env.sh
echo $$ > all.pid
{
    echo "== $(date -Is)"
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
    clang --version | head -n 1
    perf --version
    for t in $MAIN $HEAD; do echo "tree $t commit $(cat $T/$t/COMMIT)"; done
} > $M/receipt.txt 2>&1
for t in $MAIN $HEAD; do
    echo "== build $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    tail -1 $M/build-$t.log
    sha256sum $T/$t/build/compiler | tee -a $M/receipt.txt
done
$X bash -c "cd $T/$HEAD && ./build/compiler test-x86-zen5" > $M/test-x86-zen5.log 2>&1
echo "test-x86-zen5 exit $?, $(tail -n 1 $M/test-x86-zen5.log)"
for p in 1 2 3; do
    $X bash -c "cd $T/$HEAD && for c in INC_RM32/REGISTER DEC_RM32/REGISTER ADD_RM32_IMM8/REGISTER SUB_RM32_IMM8/REGISTER INC_RM64/REGISTER DEC_RM64/REGISTER ADD_RM64_IMM8/REGISTER SUB_RM64_IMM8/REGISTER; do taskset -c 2 ./build/compiler measure-x86-zen5 --only \$c --passes 11 --iterations 20000 || echo \"\$c failed\"; done" > $M/measure-$p.log 2>&1
    echo "measure $p exit $?"
done
$X bash -c ". $B/env.sh; for t in $MAIN $HEAD; do taskset -c 2 \$T/\$t/build/compiler -o $M/\$t.o \"\${COMPILE[@]}\"; echo \"\$t -c exit \$?\"; done" > $M/compile.log 2>&1
cat $M/compile.log
sha256sum $M/*.o
echo "all done $(date -Is)"
