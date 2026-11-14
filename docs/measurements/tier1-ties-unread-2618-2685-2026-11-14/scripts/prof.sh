#!/usr/bin/env bash
# prof.sh: perf record of each compiler's sqlite3.c --tier1 -c (cycles:u, pinned to CPU 2), in one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2618d-claude
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='GitHub issue #2618 (rest) and #2685: compile profile' EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB
mkdir -p $W/prof
cat > $W/prof/one.sh <<EOS
set -u
head -1 /var/lib/buster-9700x/owner >> $W/holds.txt
unset CPATH C_INCLUDE_PATH
cd /tmp
for k in 1 2 3; do
  for t in base head; do
    taskset -c 2 perf record -q -e cycles:u -c 200003 -o $W/prof/\$t-\$k.data $W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o /tmp/claude-2618d-prof-\$t.o $SQ/sqlite3.c > /dev/null 2>&1
    taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,L1-dcache-load-misses:u,dTLB-load-misses:u -o $W/prof/stat-\$t-\$k.txt $W/\$t/build/compiler --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o /tmp/claude-2618d-prof-\$t.o $SQ/sqlite3.c > /dev/null 2>&1
  done
done
rm -f /tmp/claude-2618d-prof-*.o
EOS
~/buster-fast-bench/exclusive.sh bash $W/prof/one.sh
for t in base head; do for k in 1 2 3; do perf report -q -i $W/prof/$t-$k.data --sort sym --stdio 2>/dev/null | head -400 > $W/prof/$t-$k.txt; done; done
echo done > $W/prof/done
