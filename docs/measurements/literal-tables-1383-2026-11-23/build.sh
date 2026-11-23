#!/bin/sh
# Builds base and new Release under the lock, one hold per build.
cd /tmp/1383-claude
for tree in base new; do
    EXCLUSIVE_OWNER=claude-1383 EXCLUSIVE_TITLE="buster #1383: floating record members and short rows" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383 \
    ~/buster-fast-bench/exclusive.sh timeout -k 5 1500 sh -c "cd $tree && ./build.sh --config Release" > build-$tree.log 2>&1
    echo "$tree exit=$?" >> build.status
done
