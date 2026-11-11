#!/bin/bash
# A/A control: #2243's base, head and base again in one Williams design, and #2280's, pinned to CPU 2, under the lock per run.
D=~/buster-fast-bench/1447-claude-d3
cd $D
export EXCLUSIVE_OWNER=claude-1447-d3
export EXCLUSIVE_TITLE="#1447 D3: C6b checker PRs, A/A control"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndQMcsMYmMXdjncrCg
S=$D/2280-head/src
for pr in 2243 2280; do
  ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/$pr-head/build/compiler time-runs --runs 15 --warmups 2 \
    --build base $D/$pr-base/build/compiler --build head $D/$pr-head/build/compiler --build base-again $D/$pr-base/build/compiler \
    --list -fsyntax-only -march=native -I$S -fwrapv -funsigned-char -fno-strict-aliasing -Wall $S/buster/compiler/main.c \
    > control-$pr.txt 2>&1
  echo "$pr exit $?"
done
echo CONTROL-DONE
