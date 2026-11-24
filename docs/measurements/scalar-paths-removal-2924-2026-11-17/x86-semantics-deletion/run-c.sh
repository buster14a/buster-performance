#!/bin/bash
# #2924 x86 tables' twins, piece (c): main b3f3d1b26 against head e09973e16 on the 9700X, Release. Four lock grants, one
# at a time: the two builds; then one grant for ab (3 rounds, CPU 2, base, head and base again as fresh copies) of
# -c --tier1 -g and -c of sqlite3.c (the certificate's and the straight-line check's callers run with -g); then
# benchmark-x86-semantics on head (each item alone against its batch, the AVX-512 paths' times).
set -uo pipefail
cd ~/buster-fast-bench/2924-x86
. ./env.sh
D=$PWD/c-run
mkdir -p $D/logs $D/compilers
L=~/buster-fast-bench/exclusive.sh
BASE=b3f3d1b26 HEAD_COMMIT=e09973e16
for side in base head; do
    if [ ! -d $D/src-$side ]; then git clone -q --shared $PWD/gate $D/src-$side || exit 1; fi
    git -C $D/src-$side fetch -q https://github.com/buster14a/buster main claude/2924-x86-semantics || { echo "fetch failed" >> $D/logs/status.txt; exit 1; }
done
git -C $D/src-base checkout -q --detach $BASE && git -C $D/src-head checkout -q --detach $HEAD_COMMIT
printf 'base %s\nhead %s\n' "$(git -C $D/src-base rev-parse HEAD)" "$(git -C $D/src-head rev-parse HEAD)" > $D/logs/commits.txt
for side in base head; do
    (cd $D/src-$side && $L timeout -k 5 600 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1) || { echo "build $side failed" >> $D/logs/status.txt; exit 1; }
done
cp $D/src-base/build/compiler $D/compilers/base; cp $D/src-base/build/compiler $D/compilers/base2; cp $D/src-head/build/compiler $D/compilers/head
sha256sum $D/compilers/* > $D/logs/compilers.sha256
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
S="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
cd $D
$L timeout -k 5 290 ./compilers/head ab --rounds 3 --cpu 2 compilers/base compilers/head compilers/base2 -- -c --tier1 -g -o /dev/null $S -- -c -o /dev/null $S > logs/ab.log 2>&1
echo "ab: $?" >> logs/status.txt
$L timeout -k 5 280 taskset -c 2 ./compilers/head benchmark-x86-semantics > logs/benchmark-head.log 2>&1; echo "benchmark head: $?" >> logs/status.txt
echo done >> logs/status.txt
