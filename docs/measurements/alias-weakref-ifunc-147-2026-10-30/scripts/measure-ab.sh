#!/bin/bash
# One branch against main on the 9700X: the frozen sqlite3.c's -c as whole processes (time-runs, 21 runs, five rounds
# whose trees' order rotates, each run under the lock alone, on CPU 2), the objects compared, and three perf stat runs
# of each tree's -c for user instructions. Usage: measure-ab.sh MAIN HEAD TAG TITLE LINK (MAIN and HEAD are tree
# directories here, each with its COMMIT file; HEAD is built first, under the lock alone).
cd ~/buster-fast-bench/solve-147-claude
M=$1
H=$2
T=$3
export EXCLUSIVE_OWNER=claude-solve-147 EXCLUSIVE_TITLE="$4" EXCLUSIVE_LINK="$5"
[ -x $M/build/compiler ] || { ./build-tree.sh $M; echo "build $M: $?"; }
./build-tree.sh $H; echo "build $H: $?"
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for t in $M $H; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -c "${O[@]}" -o /tmp/s$T-$t.o
    echo "$t -c: status $?"
done
cmp /tmp/s$T-$M.o /tmp/s$T-$H.o && echo "objects: identical"
./$M/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./$M ./$H \
    -- time-runs --runs 21 --list -c "${O[@]}" -o /tmp/s$T-ab.o > ab-$T.log 2>&1
echo "ab: status $?"
for t in $M $H; do
    for r in 1 2 3; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o stat-$T-$t-c-$r.csv ./$t/build/compiler -c "${O[@]}" -o /tmp/s$T-stat-$t.o
        echo "$t -c instructions (status $?): $(grep instructions stat-$T-$t-c-$r.csv | cut -d, -f1)"
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
" > hostinfo-$T.out 2>&1
echo "hostinfo: status $?"
echo done
