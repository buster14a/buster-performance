#!/usr/bin/env bash
# fit-messages.sh: the fit mutant's test at c9432ad5 with every failure printed (the test's limit of 20 lifted in this
# copy alone), run as CI runs it and under gdb with address randomization on, each step one hold of the shared lock.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
export EXCLUSIVE_OWNER=claude-140-cfg EXCLUSIVE_TITLE="Tier 1 #141: #989 review's fit mutant, every failure" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/989
lock=~/buster-fast-bench/exclusive.sh
d=$PWD/mut-tree-c9432ad5-fit
sed -i 's/if (test->failures < 20)$/if (test->failures < 100000)/' $d/src/buster/compiler/tier1_select_test.c
grep -c "failures < 100000" $d/src/buster/compiler/tier1_select_test.c
"$lock" bash -c "cd $d && BUSTER_DEBUG_INFO=0 ./build.sh > build-messages.log 2>&1; echo \"exit \$?\" >> build-messages.log"
tail -1 $d/build-messages.log
for run in 1 2 3; do
    "$lock" bash -c "cd $d && ./build/compiler test-tier1-select > messages-$run.log 2>&1; echo \"exit \$?\" >> messages-$run.log"
    echo "run $run: $(grep -v 'operand cases' $d/messages-$run.log | sort | uniq -c | sort -rn | tr '\n' '|')"
done
"$lock" bash -c "cd $d && gdb -q -batch -ex 'set disable-randomization off' -ex 'set follow-fork-mode child' -ex 'set detach-on-fork on' -ex run -ex bt -ex 'x/3i \$pc' -ex 'info registers rip rdi rsi r8' --args ./build/compiler test-tier1-select > gdb-messages.log 2>&1"
grep -v "operand cases\|^test-tier1-select: \|libthread_db\|Thread debugging" $d/gdb-messages.log | tail -25
grep "^test-tier1-select: " $d/gdb-messages.log | sort | uniq -c | sort -rn
rm -rf $d/build
echo done
