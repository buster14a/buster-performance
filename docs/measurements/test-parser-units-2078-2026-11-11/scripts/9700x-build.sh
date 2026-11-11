#!/bin/bash
# Builds base and head of #2078 on benchpress, each under its own hold of the 9700X lock.
D=~/buster-fast-bench/2078-claude
export EXCLUSIVE_OWNER=claude-2078 EXCLUSIVE_TITLE="Cut test-parser's own time, CI's longest command (#2078)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2087
for n in base head; do
    cd $D/$n || exit 1
    echo "== build $n $(date -u +%FT%TZ)"
    ~/buster-fast-bench/exclusive.sh ./build.sh > $D/build-$n.log 2>&1
    echo "exit $? $(tail -1 $D/build-$n.log)"
done
echo "== done $(date -u +%FT%TZ)"
