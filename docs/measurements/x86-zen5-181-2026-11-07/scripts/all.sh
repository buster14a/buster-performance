#!/bin/bash
# The receipt; both trees' builds; the head's test-x86-zen5; three processes of the head's measure-x86-zen5 (the table,
# then two --check of every row), each in holds of its own on CPU 2; the immediate and decoration sweep; and -c of
# sqlite3.c by both trees at Tier 0 and --tier1, whose objects must be the same bytes.
cd "$(dirname "$0")" || exit 1
. ./env.sh
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
    $X bash -c "cd $T/$t && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    tail -1 $M/build-$t.log
    sha256sum $T/$t/build/compiler | tee -a $M/receipt.txt
done
sha256sum $T/$HEAD/src/buster/compiler/x86_zen5.c $T/$HEAD/src/buster/compiler/x86_zen5_rows.c $T/$HEAD/src/buster/compiler/x86_zen5_measure.c | tee -a $M/receipt.txt
$X bash -c "cd $T/$HEAD && ./build/compiler test-x86-zen5" > $M/test-x86-zen5.log 2>&1
echo "test-x86-zen5 exit $?, $(tail -n 1 $M/test-x86-zen5.log)"
# Each process measures every row, in two holds of half the rows each (--sample 2, --offset 0 and 1), so that no hold
# keeps CI's jobs waiting past their 10 minutes.
for half in 0 1; do
    $X bash -c "cd $T/$HEAD && taskset -c 2 ./build/compiler measure-x86-zen5 --table --sample 2 --offset $half" > $M/measure-1-$half.log 2>&1
    echo "measure 1 (--table, half $half) exit $?"
done
for p in 2 3; do
    for half in 0 1; do
        $X bash -c "cd $T/$HEAD && taskset -c 2 ./build/compiler measure-x86-zen5 --check --sample 2 --offset $half" > $M/measure-$p-$half.log 2>&1
        echo "measure $p (--check, half $half) exit $?, $(grep '^# check' $M/measure-$p-$half.log)"
    done
done
# The sweep: immediates and decorations in place of the fixtures' own, and the masked rows (a merging vpaddd, a zeroing
# vmovdqu8 load) beside their unmasked ones; three processes in one hold each.
for p in 1 2 3; do
    $X bash -c "cd $T/$HEAD && for v in 0 1 3 63 127; do echo \"== --immediate \$v\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only SHL_RM64_IMM8/REGISTER --immediate \$v | grep '^# row'; done; for v in 1 3 127 -128; do echo \"== --immediate \$v\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only IMUL_R64_RM64_IMM8/REGISTER --immediate \$v | grep '^# row'; taskset -c 2 ./build/compiler measure-x86-zen5 --only ADD_RM64_IMM8/REGISTER --immediate \$v | grep '^# row'; done; for v in 0 4660 2147483647; do echo \"== --immediate \$v\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only ADD_RM32_IMM32/REGISTER --immediate \$v | grep '^# row'; done; for v in 0 132; do echo \"== --decorations \$v\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only VPADDD_Z_Z_ZM512/REGISTER --decorations \$v | grep '^# row'; taskset -c 2 ./build/compiler measure-x86-zen5 --only VADDPS_Z_Z_ZM512/REGISTER --decorations \$v | grep '^# row'; done; echo \"== merging under k7\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only VPADDD_Z_Z_ZM512/MASKED | grep '^# row'; echo \"== unmasked load\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only VMOVDQU8_Z_ZM512/MEMORY | grep '^# row'; echo \"== zeroing load under k7\"; taskset -c 2 ./build/compiler measure-x86-zen5 --only VMOVDQU8_Z_ZM512/MASKED_MEMORY | grep '^# row'" > $M/sweep-$p.log 2>&1
    echo "sweep $p exit $?"
done
$X bash -c ". $B/env.sh; for t in $MAIN $HEAD; do taskset -c 2 \$T/\$t/build/compiler -o $M/\$t-tier0.o \"\${COMPILE[@]}\"; echo \"\$t Tier 0 -c exit \$?\"; taskset -c 2 \$T/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables -o $M/\$t-tier1.o \"\${COMPILE[@]}\"; echo \"\$t --tier1 -c exit \$?\"; done" > $M/compile.log 2>&1
cat $M/compile.log
sha256sum $M/*.o
echo "all done $(date -Is)"
