#!/bin/bash
# #148's __has_builtin gates: main d12fd583 against 4c2b9fad on the frozen sqlite3.c, -E and -c as whole processes
# (time-runs, 21 runs a list), five rounds whose trees' order rotates, each run under the lock alone (ab --lock), on
# CPU 2; the objects compared; three perf stat runs of each tree's -c and -E for user instructions.
cd ~/buster-fast-bench/solve-148-claude
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="solve #137 #147 #148 (#148: __has_builtin gates A/B)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
M=main-d12fd583
H=hb-4c2b9fad
for t in $M $H; do ./build-tree.sh $t; echo "build $t: $?"; done
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for t in $M $H; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -c "${O[@]}" -o /tmp/s148-$t.o
    echo "$t -c: status $?"
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -E "${O[@]}" -o /tmp/s148-$t.i
    echo "$t -E: status $?"
done
cmp /tmp/s148-$M.o /tmp/s148-$H.o && echo "objects: identical"
cmp /tmp/s148-$M.i /tmp/s148-$H.i && echo "-E text: identical"
./$M/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./$M ./$H \
    -- time-runs --runs 21 --list -E "${O[@]}" -o /tmp/s148-ab.i --list -c "${O[@]}" -o /tmp/s148-ab.o > ab-hb.log 2>&1
echo "ab: status $?"
for t in $M $H; do
    for r in 1 2 3; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o stat-$t-c-$r.csv ./$t/build/compiler -c "${O[@]}" -o /tmp/s148-stat-$t.o
        echo "$t -c instructions (status $?): $(grep instructions stat-$t-c-$r.csv | cut -d, -f1)"
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o stat-$t-E-$r.csv ./$t/build/compiler -E "${O[@]}" -o /tmp/s148-stat-$t.i
        echo "$t -E instructions (status $?): $(grep instructions stat-$t-E-$r.csv | cut -d, -f1)"
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
" > hostinfo-hb.out 2>&1
echo "hostinfo: status $?"
echo done
