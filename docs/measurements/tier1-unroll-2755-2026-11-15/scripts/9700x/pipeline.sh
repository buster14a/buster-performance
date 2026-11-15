#!/usr/bin/env bash
# pipeline.sh: the head tree's Release build under the lock, then the kernel matrix (loops/measure.sh), then the
# compile-cost rounds (compile/compile.sh 9). Started by systemd-run so that it outlives the ssh session.
set -u
cd ~/buster-fast-bench/2755-claude || exit 1
export EXCLUSIVE_OWNER=claude-2755
export EXCLUSIVE_TITLE="Issue 2755: Tier 1 loop unrolling"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2755
echo "start $(date -u +%FT%TZ)" > pipeline.log
(cd tree-head && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > ../build-head.log 2>&1)
echo "built head $? $(date -u +%FT%TZ)" >> pipeline.log
test -x tree-head/build/compiler || { echo "no head compiler" >> pipeline.log; exit 1; }
echo "head $(cat tree-head/COMMIT) $(git -C tree-head rev-parse HEAD)" >> pipeline.log
(cd loops && ./measure.sh > measure.log 2>&1)
echo "measured $(date -u +%FT%TZ)" >> pipeline.log
(cd compile && ./compile.sh 9 > compile.log 2>&1)
echo "compiled $(date -u +%FT%TZ)" >> pipeline.log
