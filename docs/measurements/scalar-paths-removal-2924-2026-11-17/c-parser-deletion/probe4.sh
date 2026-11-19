#!/bin/bash
# #2924 C12a and C12b together: -c of sqlite3.c (and its parse) by main before C12a (a847fd0e6, #3019's merge) against
# C12b's final deletion (head2, eabcc8416), ab's three rounds around time-runs, every run under the lock on CPU 2. C12a
# and C12b each read about +0.4% on -c sqlite3.c from code placement: do they add up?
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the parser, C12b" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p probe4
git -C src-base checkout -q --detach a847fd0e6 && git -C src-base reset -q --hard
echo "pre $(git -C src-base rev-parse HEAD)" > probe4/commits.txt
(cd src-base && $L timeout -k 5 1500 ./build.sh --config Release > "$D/probe4/build-pre.log" 2>&1) || { echo "build pre failed" >> probe4/status.txt; exit 1; }
cp src-base/build/compiler compilers/pre
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
out=/dev/shm/claude-2924-c12b-probe4
BUILDS=(--build pre "$D/compilers/pre" --build head2 "$D/compilers/head2" --build pre-again "$D/compilers/pre")
for list in c-sqlite parse-sqlite; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        c-sqlite) args=(-c --lanes 1 "${S[@]}" -o "$out/sqlite3.o");;
        parse-sqlite) args=(parse -fsyntax-only "${S[@]}");;
    esac
    (cd "$out" && "$D/compilers/pre" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/pre" \
        -- time-runs --runs 3 --copies 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/probe4/time-$list.log" 2>&1)
    echo "time $list: $?" >> probe4/status.txt
done
rm -rf "$out"
echo done >> probe4/status.txt
