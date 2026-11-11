#!/usr/bin/env bash
# #2112 (#1979) follow-up: main.c -c showed +0.35..0.94% cycles with fewer instructions. Is it placement? Base and head
# each built at six placements of the checker unit, timed by time-runs under ab, the lock per run.
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-b6
export EXCLUSIVE_TITLE="B6: #2112 placement check (#1979)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2112
lock=$HOME/buster-fast-bench/exclusive.sh
export TMPDIR=$PWD/tmp
mkdir -p "$TMPDIR"
shifts="0 704 1408 2112 2752 3456"
rm -rf shifts && mkdir -p shifts
for t in base head; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$t main_unit_checker.c $shifts" > "shifts-$t.log" 2>&1 || echo "build $t failed"
done
main=(-c -march=native -I"$PWD/head/src" -fwrapv -funsigned-char "$PWD/head/src/buster/compiler/main.c")
builds=()
for b in base head; do
    for s in $shifts; do builds+=(--build "$b" "$PWD/shifts/$b/compiler-$s"); done
done
./head/build/compiler ab --rounds 3 --cpu 2 --lock "$lock" ./head/build/compiler \
    -- time-runs --runs 3 --copies 2 "${builds[@]}" --list "${main[@]}" -o /dev/null > ab-main-shifts.log 2>&1 || echo "ab failed"
echo done
