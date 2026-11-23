#!/bin/bash
# piece.sh TAG: each step under its own hold of the lock: build both trees (Release), compare bytes (default and
# --tier1), time both.
d=~/buster-fast-bench/2542-claude
export EXCLUSIVE_OWNER=claude-2542 EXCLUSIVE_TITLE="buster #2542: -g's DWARF values written once" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2542
x=~/buster-fast-bench/exclusive.sh
for t in src new; do (cd $d/$t && $x timeout -k 5 900 ./build.sh --config Release > $d/build-$t-$1.log 2>&1) || { echo build-$t-failed; exit 1; }; done
$x timeout -k 5 900 $d/compare.sh $d/src $d/new > $d/compare-$1.log 2>&1
$x timeout -k 5 900 $d/compare.sh $d/src $d/new --tier1 > $d/compare-$1-tier1.log 2>&1
$x timeout -k 5 300 $d/units.sh $d/src $1-main-u 7
$x timeout -k 5 300 $d/units.sh $d/new $1-new-u 7
$x timeout -k 5 300 $d/stages.sh $d/src $1-main-s 7
$x timeout -k 5 300 $d/stages.sh $d/new $1-new-s 7
echo done-piece
