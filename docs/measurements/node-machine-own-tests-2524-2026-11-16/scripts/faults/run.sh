#!/bin/bash
# run.sh FIRST LAST: the fault campaign of the tests' own form, on the build with every fault behind
# BUSTER_NODE_TESTS_FAULT (knobs.py): for each fault N, the census's part of test-checker (the six fixtures in both forms,
# the own form beside the census's code) and sqlite3.c's and Lua's reader-time tests in the own form with every warning
# on and the census's code beside it. A line a fault in mutations.txt: the tests' failures, and each corpus's exit status
# and expressions whose bits the two forms give differently.
set -u
dir=~/.cache/claude-2524o/faults
cd ~/.cache/claude-2524o/wt-faults
names=$(python3 $dir/knobs.py . list)
for n in $(seq $1 $2); do
    name=$(echo "$names" | sed -n "${n}p" | cut -f2)
    BUSTER_NODE_TESTS_FAULT=$n ./build/compiler test-checker --seed 133 --part 5/8 > $dir/tests-$n.log 2>&1
    failures=$(sed -n 's/^test-checker: [0-9]* checks, \([0-9]*\) failures/\1/p' $dir/tests-$n.log)
    BUSTER_NODE_TESTS_FAULT=$n ~/.cache/claude-2524s/shapes-local.sh ./build/compiler sqlite --front-own-tests --verify -Wall -Wextra > $dir/sqlite-$n.log 2>&1; sq=$?
    sqd=$(sed -n 's/.*compared-with-the-census.s-code differences=\([0-9]*\) .*/\1/p' $dir/sqlite-$n.log)
    BUSTER_NODE_TESTS_FAULT=$n ~/.cache/claude-2524s/shapes-local.sh ./build/compiler lua --front-own-tests --verify -Wall -Wextra > $dir/lua-$n.log 2>&1; lu=$?
    lud=$(sed -n 's/.*compared-with-the-census.s-code differences=\([0-9]*\) .*/\1/p' $dir/lua-$n.log)
    echo "fault $n ($name): tests ${failures:-?} failures; sqlite3.c: status $sq, ${sqd:-?} differ; Lua: status $lu, ${lud:-?} differ" >> $dir/mutations.txt
    rm -f $dir/sqlite-$n.log $dir/lua-$n.log
done
echo "done $1 $2" >> $dir/mutations.txt
