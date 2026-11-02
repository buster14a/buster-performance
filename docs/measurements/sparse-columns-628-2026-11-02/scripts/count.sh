#!/bin/bash
# count.sh: build the instrumented tree, then print the sparse columns' counts on -c sqlite3.c.
set -u
cd ~/buster-fast-bench/claude-628/instr || exit 1
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
# wait for the main profile to finish first, so the two don't race for the lock
while pgrep -f "prof.sh main-3ce71ec3" > /dev/null; do sleep 5; done
if [ ! -x build/compiler ]; then
    ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1 || { echo build failed; tail -20 build.log; exit 1; }
fi
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
BUSTER_COUNT_COLUMNS=1 ~/buster-fast-bench/exclusive.sh ./build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/null 2> counts.txt
echo done
