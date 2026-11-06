#!/bin/bash
# #868: one round of measure-compile (medians of 11) on frozen sqlite3.c and on each of Lua 5.4.8's units, for every
# build offset, with #624's fragments off and forced on (BUSTER_868_FRAGMENTS), the variants' order alternating by round.
# Run under exclusive.sh, one round per lock.
set -euo pipefail
D=$HOME/buster-fast-bench/868-claude
round=$1
offsets=(0 2048)
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
lua="$D/inputs/lua-5.4.8/src"
out="$D/results/round-$round"
mkdir -p "$out"
if (( round % 2 )); then variants=(off on); else variants=(on off); fi
date -u +%FT%TZ > "$out/started"
for off in "${offsets[@]}"; do
    for v in "${variants[@]}"; do
        if [ "$v" = on ]; then export BUSTER_868_FRAGMENTS=1; else unset BUSTER_868_FRAGMENTS; fi
        taskset -c 2 "$D/bin/compiler-$off" measure-compile --runs 11 -- "${options[@]}" > "$out/sqlite-$off-$v.txt" 2>&1
        for unit in "$lua"/*.c; do
            name=$(basename "$unit" .c)
            taskset -c 2 "$D/bin/compiler-$off" measure-compile --runs 11 -- -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "$unit" > "$out/lua-$name-$off-$v.txt" 2>&1
        done
    done
done
unset BUSTER_868_FRAGMENTS
date -u +%FT%TZ > "$out/finished"
