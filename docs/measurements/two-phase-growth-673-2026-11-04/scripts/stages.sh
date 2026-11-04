#!/bin/bash
# #673: one-lane --time-stages of SQLite -c, three runs in one lock hold.
cd ~/buster-fast-bench/unclaimed-perf-20261028
X=~/buster-fast-bench/673-claude/exp1/build/compiler
O=~/buster-fast-bench/673-claude/stages.txt
export EXCLUSIVE_OWNER=claude-673 EXCLUSIVE_TITLE="673: one-lane stage times" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673
~/buster-fast-bench/exclusive.sh bash -c "for i in 1 2 3; do taskset -c 0-7 $X --time-stages --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite -c corpus/sqlite/sqlite3.c -o /tmp/claude-673-stages.o; echo ====; done" > $O 2>&1
echo "status $?" >> $O
