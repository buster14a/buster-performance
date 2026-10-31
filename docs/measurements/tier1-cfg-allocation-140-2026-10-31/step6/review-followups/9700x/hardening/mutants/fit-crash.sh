#!/usr/bin/env bash
# fit-crash.sh: where the fit mutant's test child faults at c9432ad5: its tree built with debug information, then
# test-tier1-select under gdb, following the child; each step one hold of the shared lock.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
export EXCLUSIVE_OWNER=claude-140-cfg EXCLUSIVE_TITLE="Tier 1 #141: #989 review's fit mutant under gdb" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/989
lock=~/buster-fast-bench/exclusive.sh
d=$PWD/mut-tree-c9432ad5-fit
until grep -q "^done$" mutants.out; do sleep 10; done
"$lock" bash -c "cd $d && ./build.sh > build-gdb.log 2>&1; echo \"exit \$?\" >> build-gdb.log"
tail -1 $d/build-gdb.log
"$lock" bash -c "cd $d && gdb -q -batch -ex 'set follow-fork-mode child' -ex 'set detach-on-fork on' -ex run -ex bt -ex 'x/4i \$pc' -ex 'info registers rip rax rcx rdi rsi r8' --args ./build/compiler test-tier1-select > gdb.log 2>&1"
grep -v "operand cases" $d/gdb.log | tail -40
rm -rf $d/build
echo done
