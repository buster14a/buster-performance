#!/bin/bash
# Usage: bp-mem.sh TREE OUTDIR -- memory-event profiles of sqlite3.c -c
tree="$1"; out="$2"
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-1038 EXCLUSIVE_TITLE="GitHub issue #1038" EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzc6A3cz2qD5dSRLw
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$tree"
for ev in ls_dmnd_fills_from_sys.dram_io_all ls_dmnd_fills_from_sys.local_ccx ex_no_retire.load_not_complete; do
~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -e "$ev" -c 2000 -o "$out/perf-$ev.data" -- \
  bash -c 'for run in 1 2 3 4 5; do "$@" > /dev/null 2>&1 || exit 1; done' compile ./build/compiler "${options[@]}" -o "$out/sqlite3.o"
perf report -i "$out/perf-$ev.data" --stdio --no-children --sort symbol --percent-limit 0.5 > "$out/symbol-$ev.txt" 2>/dev/null
perf annotate -i "$out/perf-$ev.data" --stdio -s check_input_expression_coded > "$out/annotate-$ev.txt" 2>/dev/null
done
echo done > "$out/done-mem"
