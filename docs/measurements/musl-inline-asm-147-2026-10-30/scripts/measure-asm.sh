#!/bin/bash
# #147's musl inline assembly: main 7f857786 against 1398de7b (the branch with main merged). The frozen sqlite3.c's -c
# as whole processes (time-runs, 21 runs a list, five rounds whose trees' order rotates, each run under the lock alone,
# on CPU 2), the objects compared, three perf stat runs of each tree's -c for user instructions; then
# benchmark-assembler's four workloads, each process under the lock alone on CPU 2, five rounds alternating the trees.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > measure-asm.pid
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="solve #137 #147 #148 (#147: musl inline asm A/B)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
M=main-7f857786
H=asm-1398de7b
for t in $M $H; do ./build-tree.sh $t; echo "build $t: $?"; done
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for t in $M $H; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -c "${O[@]}" -o /tmp/s147-$t.o
    echo "$t -c: status $?"
done
cmp /tmp/s147-$M.o /tmp/s147-$H.o && echo "objects: identical"
./$M/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./$M ./$H \
    -- time-runs --runs 21 --list -c "${O[@]}" -o /tmp/s147-ab.o > ab-asm.log 2>&1
echo "ab: status $?"
for t in $M $H; do
    for r in 1 2 3; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o stat-$t-c-$r.csv ./$t/build/compiler -c "${O[@]}" -o /tmp/s147-stat-$t.o
        echo "$t -c instructions (status $?): $(grep instructions stat-$t-c-$r.csv | cut -d, -f1)"
    done
done
mkdir -p asmbench
for r in 1 2 3 4 5; do
    if [ $((r % 2)) -eq 1 ]; then order="$M $H"; else order="$H $M"; fi
    for t in $order; do
        for w in mixed registers simd att; do
            args=()
            [ "$w" = mixed ] || args=(--workload "$w")
            ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler benchmark-assembler "${args[@]}" > asmbench/$t-$w-$r.txt 2>&1
            echo "benchmark-assembler $t $w round $r: status $?"
        done
    done
done
~/buster-fast-bench/exclusive.sh bash -c "
uname -a
grep -m1 'model name' /proc/cpuinfo
clang --version | head -1
perf --version
echo \"cpu2 governor: \$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor), EPP: \$(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)\"
sha256sum $M/build/compiler $H/build/compiler $S/sqlite3.c
cat $M/COMMIT $H/COMMIT
" > hostinfo-asm.out 2>&1
echo "hostinfo: status $?"
echo done
