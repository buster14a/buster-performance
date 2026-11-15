#!/bin/bash
# run.sh NAME PASSES [EXTRA]: one #142 campaign, seeds 5000-5039 of each generator.
N=$1; P=$2; X=$3
G=$HOME/.cache/claude-2718/gen
B=${COMPILER:-$HOME/.cache/claude-2718/diff/compiler-566770b}
cd $HOME/.cache/claude-2718/diff
args=(--buster $B --tier0-default --tier1-arg --tier1 --tier1-arg --tier1-passes=$P)
[ "$P" = default ] && args=(--buster $B --tier0-default --tier1-arg --tier1)
[ -n "$X" ] && args+=(--tier1-arg $X)
nice -n 10 $B test-differential "${args[@]}" --csmith $G/csmith/build/src/csmith --csmith-include $G/csmith-include --yarpgen $G/yarpgen/build/yarpgen --clang clang --generator both --seed 5000 --count 40 --revision ${REVISION:-566770b} --generator-revision "csmith 0cdc710315cfee9035e22ef4363ca479270d1934 yarpgen 1adb290f453505838f3aa33dc571f292b0c1810f" --output $HOME/.cache/claude-2718/diff/$N > $N.log 2>&1
echo "exit $?" >> $N.log
