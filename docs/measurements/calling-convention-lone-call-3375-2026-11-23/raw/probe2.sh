#!/bin/bash
# The GROWN transparent union probe: PATCH as is, then with mutants3.py's mutant 3 (GROWN whatever the union), each
# built (Develop) and run through test-calling-convention under the lock.
D=~/buster-fast-bench/3375-claude
cd $D
T=mut-tree
PATCH=$1
git -C $T checkout -q -f c7809112
git -C $T apply $D/$PATCH
cp $T/src/buster/compiler/calling_convention.c calling_convention.c.probe
L="EXCLUSIVE_OWNER=claude-3375 EXCLUSIVE_TITLE=issue-3375-grown-union-probe EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3375"
for v in module grown; do
    [ $v = grown ] && python3 mutants3.py calling_convention.c.probe $T/src/buster/compiler/calling_convention.c 3
    env $L ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$T && ./build.sh > $D/probe-$v.build.log 2>&1 && ./build/compiler test-calling-convention > $D/probe-$v.log 2>&1; echo \"exit \$?\" >> $D/probe-$v.log"
done
cp calling_convention.c.probe $T/src/buster/compiler/calling_convention.c
echo done > probe-done
