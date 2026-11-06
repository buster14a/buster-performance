#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 final compiler cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
while [ ! -f parameters-v16-counts.done ] || [ ! -f latest-base-programs.done ]; do
    if [ -s parameters-v16-tests.status ] && awk '$2 != 0 { bad = 1 } END { exit !bad }' parameters-v16-tests.status; then exit 1; fi
    sleep 2
done
directory="$PWD/results/parameters-v16"
for program in st lua; do objdump -d --no-show-raw-insn "$directory/$program-t1" > "$directory/$program.dis"; done
for program in st calls tables strings arithmetic closures; do
    dis=lua
    [ "$program" != st ] || dis=st
    tools/gap count "$directory/$dis.dis" "$directory/cg/$program.out.cg" '???' 0x4000000 > "$directory/$program.tsv"
done
sql=$(awk '$3 == "extend" { n += $4 } END { print n + 0 }' "$directory/st.tsv")
lua=$(awk '$3 == "extend" { n += $4 } END { print n + 0 }' "$directory/"{calls,tables,strings,arithmetic,closures}.tsv)
printf 'SQLite extensions %s / limit 66168360; Lua %s / limit 75815270\n' "$sql" "$lua" > parameters-v16-extension-gate.txt
if [ "$sql" -gt 66168360 ] || [ "$lua" -gt 75815270 ]; then cat parameters-v16-extension-gate.txt; exit 1; fi
touch parameters-v16-extension-counts.pass
mkdir -p results/timing
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 latest-base/build/compiler time-runs --runs 11 --warmups 1 --build baseline "$PWD/latest-base/build/compiler" --build candidate "$PWD/parameters-v16/build/compiler" --list --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$PWD/corpus/sqlite" -c "$PWD/corpus/sqlite/sqlite3.c" -o "$PWD/results/timing/parameters-v16-compile.o" > parameters-v16-compile-time.log 2>&1
for build in latest-base parameters-v16; do
    (cd "$build" && "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 ./build/compiler benchmark-tier1-select-source --only select -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$HOME/buster-fast-bench/1219-codex/corpus/sqlite" "$HOME/buster-fast-bench/1219-codex/corpus/sqlite/sqlite3.c") > "parameters-v16-selection-$build.log" 2>&1
done
touch parameters-v16-cost.done
