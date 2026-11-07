#!/bin/bash
# #442: a first look on the 9700X: a few c-testsuite files on each tree, and perf's profile of current main's post-checking
# path on a 9-token unit.
cd ~/buster-fast-bench/442-claude-rebase
export EXCLUSIVE_OWNER=claude-442 EXCLUSIVE_TITLE="Solve 442" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/442
LOCK=$HOME/buster-fast-bench/exclusive.sh
S=cts/tests/single-exec
F="$S/00001.c $S/00010.c $S/00050.c $S/00100.c $S/00150.c $S/00200.c $S/00210.c"
mkdir -p probe
for t in main418 pr418 now main418 pr418 now; do
    $LOCK taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $F >> probe/$t.txt 2>&1
    sleep 5
done
many=$(for i in $(seq 100); do echo -n "$S/00001.c "; done)
$LOCK taskset -c 2 perf record -q -F 20000 -g -o probe/now-00001.data trees/now/build/compiler benchmark-emit-ab --passes 101 $many > probe/now-perf.txt 2>&1
perf report -i probe/now-00001.data --no-children --stdio --sort symbol 2>/dev/null | grep -v "^$" | grep "%" | head -60 > probe/now-00001.report
echo probe-done >> probe/now.txt
