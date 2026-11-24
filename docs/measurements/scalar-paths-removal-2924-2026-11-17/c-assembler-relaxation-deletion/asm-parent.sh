#!/bin/bash
# C11b's deletion run, the placement control: a clean build of the parent (main 968a085f) timed beside base and head,
# ab, three rounds around time-runs (five runs each), assemble of gcc's and clang's -S of sqlite3.c, under the lock.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
. ~/buster-fast-bench/2924-asm-pp-claude/env.sh
R=$D/asm-deletion
if [ ! -d $R/parent ]; then git clone -q --shared $W/src $R/parent || exit 1; fi
git -C $R/parent checkout -q --detach 968a085f
(cd $R/parent && $EX timeout -k 5 900 ./build.sh --config Release > $R/logs/build-parent.log 2>&1) || { echo "build parent failed" >> $R/logs/status.txt; exit 1; }
mkdir -p $R/compilers/hl3; for s in base head; do cp $R/compilers/$s $R/compilers/hl3/$s; done; cp $R/parent/build/compiler $R/compilers/hl3/parent
time=/dev/shm/claude-2924-asm-parent
for input in sqlite3-gcc sqlite3-clang-intel; do
    rm -rf "$time"; mkdir -p "$time"
    (cd "$time" && $R/compilers/hl3/head ab --rounds 3 --cpu 2 --lock $EX $R/compilers/hl3/head \
        -- time-runs --runs 5 --directory "$time" --build parent $R/compilers/hl3/parent --build base $R/compilers/hl3/base --build head $R/compilers/hl3/head --list assemble -o "$time/out.o" $R/inputs/$input.s > $R/logs/parent-$input.log 2>&1)
    echo "parent time $input: $?" >> $R/logs/status.txt
done
rm -rf "$time"
echo "parent done" >> $R/logs/status.txt
