#!/usr/bin/env bash
# measure-short.sh MARCH NAME...: build MARCH's configurations (one hold), then time each NAME as linked (placement 0),
# one lock hold each. measure.sh's shorter form, for when the lock is busy. Started detached; writes short.done.
set -u
cd ~/buster-fast-bench/2743-droid/loops || exit 1
export EXCLUSIVE_OWNER=droid-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 on array loops"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
LOCK=~/buster-fast-bench/exclusive.sh
export BUSTER=~/buster-fast-bench/2743-droid/tree-c471f32f/build/compiler
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
export GCC=gcc
MARCH=$1
shift
O=out/$MARCH
mkdir -p $O
rm -f short.done
$LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; ./build-9700x.sh $MARCH" > $O/build.log 2>&1
: > $O/results.txt
for NAME in "$@"; do
    [ -x $O/p0-$NAME ] || { echo "missing $NAME" >> $O/run.log; continue; }
    $LOCK ./run-one.sh $MARCH $NAME 0 >> $O/results.txt 2>> $O/run.log
done
echo "done $MARCH $(date -u +%FT%TZ)" >> progress.txt
echo done > short.done
