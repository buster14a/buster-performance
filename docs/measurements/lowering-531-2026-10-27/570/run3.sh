#!/usr/bin/env bash
# #531's third round: v4 (v2 with each statement's nodes prefetched a statement ahead) against main and v2.
set -u
cd "$(dirname "$0")"
echo $$ > run3.pid
export EXCLUSIVE_OWNER=claude-531
export EXCLUSIVE_TITLE="#531 lowering cost: a prefetch experiment"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/531
lock=$HOME/buster-fast-bench/exclusive.sh
"$lock" bash -c "cd v4 && BUSTER_DEBUG_INFO=0 ./build.sh" > build-v4.log 2>&1 || echo "build v4 failed"
"$lock" ./measure3.sh > measure3.log 2>&1 || echo "measure3 failed"
echo done
