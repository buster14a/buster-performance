#!/bin/bash
# Usage: bp-profile.sh TREE OUTDIR -- measure-compile + perf profile of sqlite3.c -c, each under the lock
tree="$1"; out="$2"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$tree"
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs 11 -- "${options[@]}" > "$out/measure.txt" 2>&1
~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -F 20000 -o "$out/perf.data" -- \
  bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile ./build/compiler "${options[@]}" -o "$out/sqlite3.o"
perf report -i "$out/perf.data" --stdio --no-children --sort symbol --percent-limit 0.3 > "$out/symbol.txt" 2>/dev/null
./build/compiler "${options[@]}" --time-stages -o "$out/sqlite3-stages.o" > "$out/stages.txt" 2>&1
echo done > "$out/done"
