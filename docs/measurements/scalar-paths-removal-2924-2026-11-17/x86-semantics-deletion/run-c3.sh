#!/bin/bash
# #2924 piece (c): head2 f17b9a439 (the debug checks' records in place) built, then in ONE grant: ab --rounds 2 --cpu 2 around
# time-runs --runs 2 --copies 2 of base, head, head2 and base again: -c --tier1 -g, -c --tier1 and -c of sqlite3.c, --lanes 1.
set -uo pipefail
cd ~/buster-fast-bench/2924-x86
. ./env.sh
D=$PWD/c-run
L=~/buster-fast-bench/exclusive.sh
git -C $D/src-head fetch -q https://github.com/buster14a/buster claude/2924-x86-semantics && git -C $D/src-head checkout -q --detach f17b9a43952073bc36b50debe01696ffac302bb3
(cd $D/src-head && $L timeout -k 5 600 ./build.sh --config Release > "$D/logs/build-head2.log" 2>&1) || { echo "build head2 failed" >> $D/logs/status.txt; exit 1; }
cp $D/src-head/build/compiler $D/compilers/head2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
out=/dev/shm/claude-2924-x86-c
rm -rf "$out"; mkdir -p "$out"
BUILDS=(--build base "$D/compilers/base" --build head "$D/compilers/head" --build head2 "$D/compilers/head2" --build base-again "$D/compilers/base2")
(cd "$out" && $L timeout -k 5 295 "$D/compilers/base" ab --rounds 2 --cpu 2 "$D/compilers/base" \
    -- time-runs --runs 2 --copies 2 --directory "$out" "${BUILDS[@]}" \
    --list -c --tier1 -g --lanes 1 "${S[@]}" -o "$out/a.o" \
    --list -c --tier1 --lanes 1 "${S[@]}" -o "$out/b.o" \
    --list -c --lanes 1 "${S[@]}" -o "$out/c.o" \
    > "$D/logs/time2.log" 2>&1)
echo "time2: $?" >> $D/logs/status.txt
rm -rf "$out"
