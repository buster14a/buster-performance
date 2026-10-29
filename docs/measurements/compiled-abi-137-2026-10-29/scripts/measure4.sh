#!/bin/bash
# The #137 A/B on the 9700X: main against the three heads (PR1 head, PR2 pr2, PR3 pr3), -c and -fsyntax-only of the
# frozen sqlite3.c as whole processes (time-runs), five rounds whose trees order rotates, each run under the lock alone
# (ab --lock), on CPU 2; then the lowering benchmark the same way; then each tree instruction profile of -c.
set -e
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137 (compiled ABI worlds: A/B of three stacked heads)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
for t in head pr2 pr3; do
    (cd $t && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1 && tail -1 build.log)
done
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for t in main head pr2 pr3; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./$t/build/compiler -c "${O[@]}" -o /tmp/cc137-$t.o
    echo "$t: status $?"
done
for t in head pr2 pr3; do
    cmp /tmp/cc137-main.o /tmp/cc137-$t.o && echo "objects: $t identical to main"
done
./main/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./main ./head ./pr2 ./pr3 \
    -- time-runs --runs 21 --list -c "${O[@]}" -o /tmp/cc137-ab.o --list -fsyntax-only "${O[@]}" > ab4-driver.log 2>&1
echo "driver: $?"
./main/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./main ./head ./pr2 ./pr3 \
    -- benchmark-lowering-source "${O[@]}" > ab4-lowering.log 2>&1
echo "lowering: $?"
for t in main head pr2 pr3; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -e instructions:u -c 200003 -o perf4-$t.data ./$t/build/compiler -c "${O[@]}" -o /tmp/cc137-perf-$t.o
    perf report -i perf4-$t.data --no-children --sort sym --stdio 2> /dev/null | grep -v "^#" | grep -v "^$" | head -80 > perf4-$t.txt
done
echo done
