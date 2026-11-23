#!/bin/bash
# #3375's mutation round: each mutant of the per-call kernel (mutants.py) built (Develop) and run through
# test-calling-convention, one lock hold per mutant. mut/status-N: "test S" (S != 0: the tests caught it) or "build S".
D=~/buster-fast-bench/3375-claude
cd $D
T=mut-tree
PATCH=$1
[ -d $T ] || git -C repo worktree add -q --detach ../$T c7809112
git -C $T checkout -q -f c7809112
git -C $T apply $D/$PATCH
cp $T/src/buster/compiler/calling_convention.c calling_convention.c.final
L="EXCLUSIVE_OWNER=claude-3375 EXCLUSIVE_TITLE=issue-3375-mutation-round EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3375"
mkdir -p mut
run()
{
    env $L ~/buster-fast-bench/exclusive.sh bash -c "cd $D/$T && if ./build.sh > $D/mut/build-$1.log 2>&1; then timeout 600 ./build/compiler test-calling-convention > $D/mut/test-$1.log 2>&1; echo \"test \$?\"; else echo \"build \$?\"; fi > $D/mut/status-$1"
}
run base
N=$(python3 mutants.py --list | wc -l)
for i in $(seq 0 $((N-1))); do
    python3 mutants.py calling_convention.c.final $T/src/buster/compiler/calling_convention.c $i
    run $i
done
cp calling_convention.c.final $T/src/buster/compiler/calling_convention.c
echo done > mut/done
