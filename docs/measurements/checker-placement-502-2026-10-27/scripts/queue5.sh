#!/usr/bin/env bash
# #473's qualification by #509's method (#473's sixth review), and #502's: main cb5736ff, #473 on it, #502 on it and
# #502 with #473, each built with the checker's unit at six placements (build.sh shifts), then -fsyntax-only of the
# frozen sqlite3.c by time-runs under ab: three copies of each executable, three runs per round, three rounds, main's
# executables again as the floor. Every build and time-runs process takes the lock alone.
set -u
here="$HOME/buster-fast-bench/checker-placement-502"
q="$here/q5"
cd "$q"
. "$HOME/buster-fast-bench/pp-117-templates/args.sh"
shifts="0 688 1376 2064 2752 3440"
for tree in main h473 s502 s502h473; do
    (cd $tree && BUSTER_DEBUG_INFO=0 "$here/locked.sh" ./build.sh shifts ../shifts/$tree main_unit_checker.c $shifts) \
        > results/build-$tree.txt 2>&1 || { echo "build $tree failed"; exit 1; }
done
sha256sum shifts/*/compiler-* > results/sha.txt
for tree in main s502; do
    for s in 0 2064; do printf '%s %s ' $tree $s; nm shifts/$tree/compiler-$s | awk '$3 == "check_input_expressions" || $3 == "check_literal_number_plain" {printf "%s=%s ", $3, $1}'; echo; done
done > results/addresses.txt
builds=()
for b in main:main h473:h473 s502:s502 s502h473:s502h473 main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$q/shifts/${b#*:}/compiler-$s"); done
done
main/build/compiler ab --rounds 3 --cpu 2 --lock "$here/locked.sh" "$q/main/build/compiler" \
    -- time-runs --runs 3 --copies 3 "${builds[@]}" --list -fsyntax-only "${sqlite[@]}" > results/ab.txt 2>&1
echo done > results/queue5.done
