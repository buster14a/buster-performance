#!/bin/bash
# prof.sh TREE: build TREE (one hold), then profile -c sqlite3.c (another hold).
set -u
tree=$1
cd ~/buster-fast-bench/claude-628/$tree || exit 1
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
if [ ! -x build/compiler ]; then
    ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1 || { echo build failed; tail -20 build.log; exit 1; }
fi
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
mkdir -p prof
~/buster-fast-bench/exclusive.sh bash -c '
  taskset -c 2 ./build/compiler "$@" -o prof/sqlite3.o --time-stages 2> prof/stages.txt
  taskset -c 2 perf stat -r 5 -e task-clock,page-faults,cycles:u,instructions:u,cycles:k -o prof/stat.txt -- ./build/compiler "$@" -o prof/sqlite3.o
  taskset -c 2 perf record -q -F 20000 -o prof/perf.data -- bash -c "for run in 1 2 3 4 5; do \"\$@\" > /dev/null 2>&1 || exit 1; done" compile ./build/compiler "$@" -o prof/sqlite3.o
' prof "${options[@]}"
perf report -i prof/perf.data --stdio --no-children --sort symbol --percent-limit 0.3 2>/dev/null | grep -v '^#' | sed '/^$/d' | head -70 > prof/symbol.txt
echo done
