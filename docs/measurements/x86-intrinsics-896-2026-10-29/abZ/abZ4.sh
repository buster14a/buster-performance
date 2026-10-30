#!/bin/bash
# A third control of abZ2's difference in user cycles: its comparison over placements again, with main.c's own unit
# shifted, the first source, so that every unit's code moves with it (abZ2 shifted the checker's unit and abZ3 the front
# end's, neither of which moves main.c's unit or main_unit_x86.c, which come before them). Every time-runs process takes
# the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): 9d's head against its parent, main.c's placements" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abZ
export TMPDIR=$here/tmp
mkdir -p "$TMPDIR"
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd "$here"
shifts="0 768 1536 2304 3072 3840"
copies=/tmp/claude-126-abZ4
rm -rf whole && mkdir whole
for tree in base h9d; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh shifts ../whole/$tree main.c $shifts > ../whole_$tree.log 2>&1) || { echo "main.c shifts $tree failed"; tail -3 whole_$tree.log; exit 1; }
    echo "shifted $tree's main.c: $(grep -c 'bytes later' whole_$tree.log) placements"
done
builds=()
for b in base:base h9d:h9d base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "whole/${b#*:}/compiler-$s"); done
done
rm -rf "$copies" && mkdir -p "$copies"
base/build/compiler ab --rounds 3 --cpu 2 --lock $lock base/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory "$copies" "${builds[@]}" --list -c -o /dev/null "${lower[@]}" --list -fsyntax-only "${check[@]}" > whole.log 2>&1
echo "ab status $?"
rm -rf "$copies"
sha256sum whole/*/compiler-* > abZ4.sha256
echo done
