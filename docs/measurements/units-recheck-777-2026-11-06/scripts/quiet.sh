#!/bin/bash
# #1340's share: synth's link by 8 lanes and by one, and Lua's link by one lane, with -w (which skips main's common
# warnings, #1049's pass, as `quiet`), by the tree and by #763, one time-runs on CPUs 0 to 7.
# Usage: quiet.sh TREE BASE
. $(dirname $0)/common.sh
TREE=${1:?tree}
BASE=${2:?base tree}
H=$W/$TREE/build/compiler
B=$W/$BASE/build/compiler
d=$W/quiet-$TREE
rm -rf $d && mkdir -p $d/1 $d/2 $d/3 $d/4 $d/5 $d/6 && cd $d
P="taskset -c 0-7"
syn=$(ls $HOME/buster-fast-bench/units-152-claude/explore/synth/unit_*.c | tr '\n' ' ')
src=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
lua=$(cd $src && ls *.c | grep -v '^luac.c$' | sed "s|^|$src/|" | tr '\n' ' ')
lf="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
echo "lists, all with -w: 1-2 synth --lanes 8 by $TREE, $BASE; 3-4 synth --lanes 1 by $TREE, $BASE; 5-6 Lua --lanes 1 by $TREE, $BASE"
lists=()
lists+=(--list -c "cd $d/1 && $P $H -w --lanes 8 -o synth $syn")
lists+=(--list -c "cd $d/2 && $P $B -w --lanes 8 -o synth $syn")
lists+=(--list -c "cd $d/3 && $P $H -w --lanes 1 -o synth $syn")
lists+=(--list -c "cd $d/4 && $P $B -w --lanes 1 -o synth $syn")
lists+=(--list -c "cd $d/5 && $P $H -w --lanes 1 $lf -o lua $lua -lm -ldl")
lists+=(--list -c "cd $d/6 && $P $B -w --lanes 1 $lf -o lua $lua -lm -ldl")
lock $H time-runs --executable /bin/sh --runs ${RUNS:-7} "${lists[@]}" > runs.log 2>&1
statuses runs.log; results < runs.log
for x in 1 2 3 4; do ./$x/synth | tail -1; done; for x in 5 6; do echo 'print(6 * 7)' | ./$x/lua -; done
echo quiet-finished
