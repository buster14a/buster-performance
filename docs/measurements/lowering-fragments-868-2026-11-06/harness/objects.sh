#!/bin/bash
# #868: each build's objects of sqlite3.c and Lua's units with the fragments off and forced on, which must be the same
# bytes, and the lowering's coverage of each (--time-stages' lowering-nodes); then perf's counters of 11 sqlite3.c
# compiles of each variant at offset 0. Run under exclusive.sh.
set -euo pipefail
D=$HOME/buster-fast-bench/868-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
lua="$D/inputs/lua-5.4.8/src"
out="$D/results/objects"
mkdir -p "$out"
for off in 0 2048; do
    for v in off on; do
        if [ "$v" = on ]; then export BUSTER_868_FRAGMENTS=1; else unset BUSTER_868_FRAGMENTS; fi
        mkdir -p "$out/$off-$v"
        taskset -c 2 "$D/bin/compiler-$off" --time-stages "${options[@]}" -o "$out/$off-$v/sqlite3.o" 2>&1 | grep lowering-nodes | sed 's/^/sqlite3 /' >> "$out/coverage-$off-$v.txt"
        for unit in "$lua"/*.c; do
            name=$(basename "$unit" .c)
            taskset -c 2 "$D/bin/compiler-$off" --time-stages -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX "$unit" -o "$out/$off-$v/$name.o" 2>&1 | grep lowering-nodes | sed "s/^/$name /" >> "$out/coverage-$off-$v.txt"
        done
        (cd "$out/$off-$v" && sha256sum *.o) > "$out/objects-$off-$v.sha256"
    done
done
unset BUSTER_868_FRAGMENTS
for off in 0 2048; do
    for v in off on; do
        cmp "$out/objects-0-off.sha256" "$out/objects-$off-$v.sha256" && echo "objects $off-$v: same as 0-off"
    done
done
for v in off on on off; do
    if [ "$v" = on ]; then export BUSTER_868_FRAGMENTS=1; else unset BUSTER_868_FRAGMENTS; fi
    echo "== perf stat, offset 0, fragments $v"
    taskset -c 2 perf stat -r 11 -e cycles:u,instructions:u,branch-misses:u -- "$D/bin/compiler-0" "${options[@]}" -o "$out/counted.o" 2>&1
done
