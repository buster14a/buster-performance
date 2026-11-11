#!/bin/bash
# C4b #2326: base vs head over six placements of the checker's unit (docs/profiling.md, #509), each build under the lock.
B=~/buster-fast-bench/1447-c4b-claude
export EXCLUSIVE_OWNER=claude-c4b EXCLUSIVE_TITLE="C4b type sugar placements #2326" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2326
shifts="0 704 1408 2112 2752 3456"
for t in base head; do
    (cd $B/$t && ~/buster-fast-bench/exclusive.sh ./build.sh shifts $B/shifts/$t main_unit_checker.c $shifts > $B/shifts-$t.log 2>&1; echo "$t shifts exit $?")
done
builds=()
for b in base:base head:head base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$B/shifts/${b#*:}/compiler-$s"); done
done
cd $B/base
S=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
M="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c"
$B/head/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh $B/head/build/compiler \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -fsyntax-only $S --list -fsyntax-only $M --list -c $M -o /tmp/c4b-main.o
echo "shifts ab exit $?"
