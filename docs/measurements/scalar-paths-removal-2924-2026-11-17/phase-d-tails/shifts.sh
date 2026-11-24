#!/bin/bash
# #3448 tails: sqlite3.c -c --lanes 1 by base and head over six placements of the checker's unit (#509), three
# copies each, three ab rounds on CPU 2. Builds and runs under the lock, each run alone.
set -uo pipefail
cd ~/buster-fast-bench/2924-program/tails
export EXCLUSIVE_OWNER=claude-2924-c12c4 EXCLUSIVE_TITLE="buster #2924: phase D, the checker tails (#3448)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3448
L=~/buster-fast-bench/exclusive.sh
shifts="0 704 1408 2112 2816 3520"
mkdir -p shifts logs
: > logs/shifts-status.txt
for tree in base head; do
    (cd src-$tree && $L timeout -k 5 1500 ./build.sh shifts ../shifts/$tree main_unit_checker.c $shifts > ../logs/shifts-build-$tree.log 2>&1); echo "shifts $tree: $?" >> logs/shifts-status.txt
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
out=/dev/shm/claude-2924-tails-shifts
rm -rf $out; mkdir -p $out
builds=()
for b in base:base head:head base-again:base; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "$PWD/shifts/${b#*:}/compiler-$s"); done
done
(cd $out && ~/buster-fast-bench/2924-program/tails/compilers/base ab --rounds 3 --cpu 2 --lock $L ~/buster-fast-bench/2924-program/tails/compilers/base \
    -- time-runs --runs 3 --copies 3 --directory $out "${builds[@]}" --list -c --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$corpus" "$corpus/sqlite3.c" -o $out/sqlite3.o \
    > ~/buster-fast-bench/2924-program/tails/logs/time-sqlite-shifts.log 2>&1)
echo "time: $?" >> logs/shifts-status.txt
rm -rf $out
echo done >> logs/shifts-status.txt
