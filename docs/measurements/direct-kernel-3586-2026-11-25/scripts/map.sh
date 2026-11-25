#!/bin/bash
# map.sh NAME: bin/compiler-NAME (built with patches/arena-map.patch) compiles sqlite3.c with base pages and reports
# which 4 KB pages of each arena its compile touched, by allocation and by 2 MB region; then with the default pages.
set -uo pipefail
here=$HOME/buster-fast-bench/3586-claude
name=$1
bin=$here/bin/compiler-$name
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
      -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
      -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
chmod +x "$bin"
BUSTER_HUGE_PAGES=0 BUSTER_DIRECT_ARENA_MAP=1 taskset -c 2 "$bin" "${unit[@]}" -o /dev/shm/3586-map.o > "$here/results/map-$name-base.txt" 2>&1
BUSTER_DIRECT_ARENA_MAP=1 taskset -c 2 "$bin" "${unit[@]}" -o /dev/shm/3586-map.o > "$here/results/map-$name-huge.txt" 2>&1
rm -f /dev/shm/3586-map.o
