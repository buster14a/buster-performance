#!/bin/bash
# An A/B of buster trees on the 9700X for #137's remaining pull requests: each tree built under the lock alone, then
# -c and -fsyntax-only of the frozen sqlite3.c as whole processes (time-runs), five rounds whose trees' order rotates,
# each run under the lock alone (ab --lock), on CPU 2; then each tree's user instructions of both (perf stat, 3 runs).
# Usage: measure.sh NAME TREE... (directories under ~/buster-fast-bench/cc137-claude; the first is the reference).
set -e
name=$1; shift
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137's remaining work (A/B: $name)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
for t in "$@"; do
    if [ ! -x $t/build/compiler ]; then
        (cd $t && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1 && tail -1 build.log)
    fi
done
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for t in "$@"; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -c "${O[@]}" -o /tmp/cc137-$name-$t.o
done
for t in "$@"; do
    cmp -s /tmp/cc137-$name-$1.o /tmp/cc137-$name-$t.o && echo "objects: $t identical to $1" || echo "objects: $t differs from $1"
done
trees=()
for t in "$@"; do trees+=(./$t); done
./$1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "${trees[@]}" \
    -- time-runs --runs 21 --list -c "${O[@]}" -o /tmp/cc137-$name-ab.o --list -fsyntax-only "${O[@]}" > $name-driver.log 2>&1
echo "driver: $?"
for t in "$@"; do
    for r in 1 2 3; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o $name-stat-c-$t-$r.csv ./$t/build/compiler -c "${O[@]}" -o /tmp/cc137-$name-stat-$t.o
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u -o $name-stat-s-$t-$r.csv ./$t/build/compiler -fsyntax-only "${O[@]}"
        echo "$t -c: $(grep instructions $name-stat-c-$t-$r.csv | cut -d, -f1) -fsyntax-only: $(grep instructions $name-stat-s-$t-$r.csv | cut -d, -f1)"
    done
done

./$1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "${trees[@]}" \
    -- benchmark-lowering-source "${O[@]}" > $name-lowering.log 2>&1
echo "lowering: $?"
echo done
