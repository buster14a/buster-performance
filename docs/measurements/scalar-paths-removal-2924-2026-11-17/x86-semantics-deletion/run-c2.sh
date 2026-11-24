#!/bin/bash
# #2924 piece (c): whole compiles, base b3f3d1b26 against head e09973e16 and base again, in ONE lock grant: ab --rounds 2
# --cpu 2 around time-runs --runs 2 --copies 2 (fresh copies), -c --tier1 -g and -c of sqlite3.c, --lanes 1.
set -uo pipefail
cd ~/buster-fast-bench/2924-x86
. ./env.sh
D=$PWD/c-run
L=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
out=/dev/shm/claude-2924-x86-c
rm -rf "$out"; mkdir -p "$out"
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build base-again "$D/compilers/base2")
(cd "$out" && $L timeout -k 5 295 "$D/compilers/base" ab --rounds 2 --cpu 2 "$D/compilers/base" \
    -- time-runs --runs 2 --copies 2 --directory "$out" "${BUILDS[@]}" \
    --list -c --tier1 -g --lanes 1 "${S[@]}" -o "$out/sqlite3-tier1-g.o" \
    --list -c --lanes 1 "${S[@]}" -o "$out/sqlite3.o" \
    > "$D/logs/time.log" 2>&1)
echo "time: $?" >> $D/logs/status.txt
rm -rf "$out"
