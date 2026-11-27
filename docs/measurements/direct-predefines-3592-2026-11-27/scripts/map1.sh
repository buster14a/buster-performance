#!/bin/bash
# map1.sh NAME UNIT ENV...: one page map with extra environment (e.g. BUSTER_HUGE_PAGES=0), to results/map-NAME-UNIT-TAG.txt
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude2
name=$1; unit=$2; tag=$3; shift 3
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
printf 'int add(int a, int b) { return a + b; }\n' > /dev/shm/map1-3586-add.c
case $unit in
    add) args=("${base[@]}" -c /dev/shm/map1-3586-add.c);;
    sqlite) args=("${base[@]}" "${sys[@]}" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c");;
    lua-*) args=(--lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$here/lua/src/${unit#lua-}.c");;
esac
env "$@" BUSTER_DIRECT_ARENA_MAP=1 taskset -c 2 "$here/bin/compiler-$name" "${args[@]}" -o /dev/shm/map1-3586.o > "$here/results/map-$name-$unit-$tag.txt" 2>&1
rm -f /dev/shm/map1-3586.o
head -n 2 "$here/results/map-$name-$unit-$tag.txt"
