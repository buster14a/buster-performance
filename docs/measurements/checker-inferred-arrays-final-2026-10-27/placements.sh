#!/bin/bash
# #555's placements (abi17's trees: main 51bf882b and be3e7ec1): each tree's executable at six placements of the checker's
# unit and what follows it (build.sh shifts), then -fsyntax-only of the frozen sqlite3.c by every placement, three copies each,
# with main's again as the comparison's floor: ab's three rounds, each time-runs process under its own hold of the lock,
# pinned to CPU 2 (docs/profiling.md, "Builds over their code's placements and copies").
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: an inferred array's walk, placements A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/555
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export TMPDIR=~/buster-fast-bench/solve-126-claude/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd ~/buster-fast-bench/solve-126-claude/abi17
shifts="0 688 1376 2064 2752 3440"
for tree in base head; do
    (cd $tree && $lock env BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh shifts ../shifts/$tree main_unit_checker.c $shifts > ../shifts_$tree.log 2>&1) || { echo "shifts $tree failed"; exit 1; }
    echo "shifts $tree built"
done
sha256sum shifts/*/compiler-* > shifts.sha256
builds=()
for b in main:base head:head main-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "shifts/${b#*:}/compiler-$s"); done
done
./head/build/compiler ab --rounds 3 --cpu 2 --lock $lock ./head/build/compiler -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -fsyntax-only "${lower[@]}" > ab_placements.log 2>&1
echo "ab placements status $?"
echo done
