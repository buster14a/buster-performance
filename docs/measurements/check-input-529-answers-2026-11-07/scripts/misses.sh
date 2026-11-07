#!/bin/bash
# Branch misses and cycles by instruction of -c sqlite3.c (main m2's build), each step under the 9700X's lock.
base=~/buster-fast-bench/529-claude-galileo
out="$base/out-m2"
export EXCLUSIVE_OWNER=claude-529-galileo EXCLUSIVE_TITLE="#529 branch misses" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/529
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
$ex taskset -c 2 perf record -q -e branch-misses:u -c 2000 -o "$out/misses.data" -- \
  bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile "$out/compiler" "${options[@]}" -o "$out/m.o"
$ex bash -c "perf script -i '$out/misses.data' -F ip,sym,symoff,dso > '$out/misses.txt' 2>/dev/null"
echo done > "$out/MISSES-DONE"
