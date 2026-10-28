#!/usr/bin/env bash
set -euo pipefail
cd /home/david/buster-fast-bench/unclaimed-perf-20261028
mode=$1
first=./base96a4-fill/build/compiler
second=./issue628-fill95be/build/compiler
case "$mode" in
    *-aa) second=$first ;;
    *-ba) swap=$first; first=$second; second=$swap ;;
esac
flags=(--lanes 1 -c)
if [[ $mode == sql-* ]]; then
    source=corpus/sqlite/sqlite3.c
    flags+=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
            -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu
            -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include
            -isystem corpus/headers/usr/include -Icorpus/sqlite)
else
    source=fill-tools95be/uchar800000.c
fi
flags+=("$source" -o @OUTPUT@)
exec ./samples 21 1 1 "$source" "fill-tools95be/$mode" ./cohort "$first" "$second" "${flags[@]}"
