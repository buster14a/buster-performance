#!/usr/bin/env bash
# #531's final round: the branch's head, and with #520's stage clock, against main.
set -u
cd "$(dirname "$0")"
echo $$ > run4.pid
export EXCLUSIVE_OWNER=claude-531
export EXCLUSIVE_TITLE="#531 lowering cost: main against the branch's head"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/531
lock=$HOME/buster-fast-bench/exclusive.sh
# /tmp is a tmpfs that can run out of inodes; keep this run's temporary files on the home disk.
export TMPDIR=$PWD/tmp
mkdir -p "$TMPDIR"
for t in final final-520; do
    "$lock" bash -c "cd $t && BUSTER_DEBUG_INFO=0 ./build.sh" > "build-$t.log" 2>&1 || echo "build $t failed"
done
"$lock" ./measure4.sh > measure4.log 2>&1 || echo "measure4 failed"
echo done
