#!/bin/bash
# The receipt, the builds, the head's Tier 1 suites (each a hold of its own), then five rounds of benchmark-tier1-select
# by both trees, each round one hold, in an order alternating by round, pinned to CPU 2: the full run (selection and
# complete phases, both paths), then the complete phase's vector path alone after 200 ms of its scalar twin.
cd "$(dirname "$0")" || exit 1
. ./env.sh
echo $$ > all.pid
{
    echo "== $(date -Is)"
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
    clang --version | head -n 1
    for t in $MAIN $HEAD; do echo "tree $t commit $(cat $T/$t/COMMIT)"; done
} > $M/receipt.txt 2>&1
for t in $MAIN $HEAD; do
    echo "== build $t $(date -Is)"
    $X bash -c "cd $T/$t && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-$t.log 2>&1 || { echo "build $t failed"; tail -5 $M/build-$t.log; exit 1; }
    tail -1 $M/build-$t.log
    sha256sum $T/$t/build/compiler | tee -a $M/receipt.txt
done
mkdir -p $M/tests
for c in test-tier1-select test-tier1-emit "test-tier1-pipeline --cross-check" test-tier1-liveness test-tier1-allocation test-tier1-frame-execution test-x86-semantics; do
    n=$(echo "$c" | tr -d ' -')
    $X bash -c "cd $T/$HEAD && ./build/compiler $c" > $M/tests/$n.log 2>&1
    echo "$n: exit $?, $(grep -v 'operand cases' $M/tests/$n.log | tail -n 1)"
done
mkdir -p $M/bench
for r in 1 2 3 4 5; do
    if [ $((r % 2)) = 1 ]; then order="$MAIN $HEAD"; else order="$HEAD $MAIN"; fi
    $X bash -c "for t in $order; do cd $T/\$t && taskset -c 2 ./build/compiler benchmark-tier1-select > $M/bench/full-\$t-$r.log 2>&1; echo \"full \$t $r \$?\"; taskset -c 2 ./build/compiler benchmark-tier1-select --only vector --after-scalar 200 > $M/bench/after-\$t-$r.log 2>&1; echo \"after \$t $r \$?\"; done" > $M/bench/round-$r.log 2>&1
    grep -E "^(full|after) " $M/bench/round-$r.log
done
echo "all done $(date -Is)"
