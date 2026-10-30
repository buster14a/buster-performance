#!/bin/bash
# abZ's sqlite3.c runs over the builds' code placements and fresh copies (docs/profiling.md, "Builds over their code's
# placements and copies", #509): each tree of abZ linked again with its checker unit's code shifted by six offsets over
# a page (./build.sh shifts), under its own hold of the 9700X's lock; then ab's three rounds of time-runs, each of three
# runs of every placement from three fresh copies on tmpfs, the builds alternating in an order that rotates by run, of
# -c and of -fsyntax-only of the frozen sqlite3.c, as abZ runs them. base-again, base's placements a second time, is
# the comparison's own floor. Every time-runs process takes the lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): 9d's head against its parent, over placements" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
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
shifts="0 688 1376 2064 2752 3440"
copies=/tmp/claude-126-abZ2
cd "$here"
rm -rf shifts && mkdir shifts
for tree in base h9d; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh shifts ../shifts/$tree main_unit_checker.c $shifts > ../shifts_$tree.log 2>&1) || { echo "shifts $tree failed"; exit 1; }
    echo "shifted $tree: $(grep -c 'bytes later' shifts_$tree.log) placements"
done
builds=()
for b in base:base h9d:h9d base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "shifts/${b#*:}/compiler-$s"); done
done
rm -rf "$copies" && mkdir -p "$copies"
base/build/compiler ab --rounds 3 --cpu 2 --lock $lock base/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory "$copies" "${builds[@]}" --list -c -o /dev/null "${lower[@]}" --list -fsyntax-only "${check[@]}" > placements.log 2>&1
echo "ab status $?"
rm -rf "$copies"
sha256sum shifts/*/compiler-* > shifts.sha256
echo done
