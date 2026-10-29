#!/bin/bash
# The PR's final head (ecb3fcfd: the measured head, cff7bc98, with #180's rows for Tier 0's VL forms and the scalar
# twin's table, neither of which -c runs): one hold builds it; then three rounds of -c of the frozen sqlite3.c with the
# 9700X job's compile-time options by main and the final head (perf stat's 11 runs each, the order alternating by
# round, each run's exit status logged), and one hold of benchmark-x86-semantics by each; then the receipts (the host,
# the tools, CPU 2's governor, the binaries' and the inputs' hashes).
. "$(dirname "$0")/env.sh"
mkdir -p $M/final
$X bash -c "cd $T/final && BUSTER_DEBUG_INFO=0 ./build.sh" > $M/build-final.log 2>&1 || { echo "build final failed"; tail -5 $M/build-final.log; exit 1; }
sha256sum $T/final/build/compiler
round() { # r first second
    local r=$1
    shift
    for t in "$@"; do
        taskset -c 2 perf stat -r 11 -x, -e task-clock,cycles:u,instructions:u -o $M/final/$t-$r.csv $T/$t/build/compiler -o $M/final/$t.o "${COMPILE[@]}" > $M/final/$t-$r.out 2>&1
        echo "$t round $r: status $?" >> $M/final/status.txt
    done
}
export -f round
for r in 1 2 3; do
    if [ $((r % 2)) -eq 1 ]; then $X bash -c ". $B/env.sh; round $r main final"; else $X bash -c ". $B/env.sh; round $r final main"; fi
done
$X bash -c ". $B/env.sh; for t in main final; do taskset -c 2 \$T/\$t/build/compiler benchmark-x86-semantics > \$M/final/sem-\$t.log 2>&1; echo \"sem \$t: status \$?\" >> \$M/final/status.txt; done"
{
    uname -a
    clang --version | head -1
    perf --version
    lscpu | grep -E '^Model name|^CPU\(s\)|^On-line'
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    sha256sum $T/main/build/compiler $T/head/build/compiler $T/nosub/build/compiler $T/final/build/compiler
    sha256sum $M/compile/*.o $M/final/*.o
    sha256sum "$CORPUS/sqlite/sqlite3.c" "$Q/sqlite3.c" "$SRC/speedtest1.c"
    cat $T/*.commit
} > $M/receipt.txt 2>&1
echo "final done $(date -Is)"
