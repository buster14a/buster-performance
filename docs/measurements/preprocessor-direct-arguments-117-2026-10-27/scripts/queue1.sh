#!/usr/bin/env bash
# #117's arguments of direct objects: main 530304fc against the branch's 0a855133, each built with the preprocessor's
# unit (main_unit_frontend.c) at six placements (build.sh shifts). Then benchmark-preprocessor's deferred run
# (--history-cost --only scalar) on sqlite3.c and main.c at every placement of main, the branch and main again, two
# rounds with the builds' order rotating; then -E, parse and -fsyntax-only of sqlite3.c as whole processes, by
# time-runs --copies 3 under ab, three rounds. Every build and run takes the lock alone, on CPU 2.
set -u
here="$HOME/buster-fast-bench/pp-117-arguments"
cd "$here"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
r=results
mkdir -p $r shifts
shifts="0 704 1408 2112 2816 3520"
for tree in main head; do
    (cd $tree && BUSTER_DEBUG_INFO=0 "$here/locked.sh" ./build.sh shifts ../shifts/$tree main_unit_frontend.c $shifts) > $r/build-$tree.txt 2>&1 || { echo "build $tree failed"; exit 1; }
done
sha256sum shifts/*/compiler-* > $r/sha.txt
builds=(main:main head:head again:main)
for round in 1 2; do
    for k in 0 1 2; do
        b=${builds[$(((k + round - 1) % 3))]}
        for s in $shifts; do
            "$here/locked.sh" taskset -c 2 shifts/${b#*:}/compiler-$s benchmark-preprocessor --history-cost --only scalar "${sqlite[@]}" > $r/sqlite-${b%%:*}-$s-$round.txt 2>&1
        done
    done
done
for round in 1 2; do
    for k in 0 1 2; do
        b=${builds[$(((k + round - 1) % 3))]}
        for s in $shifts; do
            "$here/locked.sh" taskset -c 2 shifts/${b#*:}/compiler-$s benchmark-preprocessor --history-cost --only scalar "${mainc[@]}" > $r/mainc-${b%%:*}-$s-$round.txt 2>&1
        done
    done
done
list=()
for b in main:main head:head again:main; do
    for s in $shifts; do list+=(--build "${b%%:*}" "$here/shifts/${b#*:}/compiler-$s"); done
done
main/build/compiler ab --rounds 3 --cpu 2 --lock "$here/locked.sh" "$here/main/build/compiler" \
    -- time-runs --runs 3 --copies 3 "${list[@]}" --list -E "${sqlite[@]}" -o /dev/null --list parse -fsyntax-only "${sqlite[@]}" --list -fsyntax-only "${sqlite[@]}" \
    > $r/drivers.txt 2>&1
echo done > $r/queue1.done
