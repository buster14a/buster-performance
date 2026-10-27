#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
root=$(pwd)
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=codex-593
export EXCLUSIVE_TITLE="Buster #593 SQLite control and instruction counts"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/593
lock="$HOME/buster-fast-bench/exclusive.sh"
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
sha256sum "$sqlite/sqlite3.c" /usr/bin/tcc > logs/control-inputs.sha256
for round in 0 1 2 3; do
    versions=(base head)
    if ((round % 2)); then versions=(head base); fi
    for version in "${versions[@]}"; do
        "$lock" taskset -c 2 "../$version/build/compiler" measure-compile --runs 11 --warmups 2 \
            --directory "$root/tmp" -- "${options[@]}" \
            > "logs/sqlite-$round-$version.log" 2> "logs/sqlite-$round-$version-lock.log"
        "$lock" taskset -c 2 perf stat -x, -r 3 -e instructions:u,cycles:u \
            -o "logs/sqlite-$round-$version-perf.csv" -- "../$version/build/compiler" "${options[@]}" -o "objects/sqlite-$version.o" \
            > "logs/sqlite-$round-$version-perf.log" 2> "logs/sqlite-$round-$version-perf-lock.log"
    done
done
cmp objects/sqlite-base.o objects/sqlite-head.o
echo 'sqlite byte_identical=1 status=0'
for version in base head; do
    "$lock" taskset -c 2 perf stat -x, -r 3 -e instructions:u,cycles:u \
        -o "logs/strings-160000-$version-perf.csv" -- "../$version/build/compiler" -c inputs/strings-160000.c -o "objects/strings-160000-$version.o" \
        > "logs/strings-160000-$version-perf.log" 2> "logs/strings-160000-$version-perf-lock.log"
done
cmp objects/strings-160000-base.o objects/strings-160000-head.o
echo 'string_counters byte_identical=1 status=0'
