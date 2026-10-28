#!/bin/bash
# profile.sh TREE: perf profile of -c sqlite3.c (the compile-time step's options), 5 compiles, by symbol, under the lock.
cd ~/buster-fast-bench/member-591-claude/"$1" || exit 1
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=~/buster-fast-bench/member-591-claude/"$1"/profile
mkdir -p "$out"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
~/buster-fast-bench/member-591-claude/lock.sh bash -c '
taskset -c 2 perf stat -r 11 -e task-clock,page-faults,cycles:u,instructions:u -o "$0/stat.txt" -- ./build/compiler "$@" -o "$0/sqlite3.o"
taskset -c 2 perf record -q -F 20000 -g -o "$0/perf.data" -- bash -c "for run in 1 2 3 4 5; do \"\$@\" > /dev/null 2>&1 || exit 1; done" compile ./build/compiler "$@" -o "$0/sqlite3.o"
' "$out" "${options[@]}"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol --percent-limit 0.1 > "$out/symbol.txt" 2>/dev/null
perf report -i "$out/perf.data" --stdio --no-children --sort dso,symbol -g caller --percent-limit 0.3 > "$out/callers.txt" 2>/dev/null
echo "profile done" >> "$out/stat.txt"
