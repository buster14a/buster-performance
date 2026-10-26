#!/bin/bash
export EXCLUSIVE_OWNER=claude-complex-133 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/133"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
for round in 1 2; do
    for d in complex-133-main complex-133-claude; do
        cd $B/$d || exit 1
        $X taskset -c 2 ./build/compiler time-runs --runs 21 --warmups 3 --list -c -I$Q -o $B/$d/sqlite3.o $Q/sqlite3.c > sqlite-$round.log 2>&1
        echo "== $d $round: $?"; grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:" sqlite-$round.log | grep "^list"
    done
done
