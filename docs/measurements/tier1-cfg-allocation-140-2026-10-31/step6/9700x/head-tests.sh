#!/usr/bin/env bash
# head-tests.sh TREE: Tier 1's tests and c-testsuite's subset by --tier1 on TREE's build, each one hold of the shared lock.
set -u
cd ~/buster-fast-bench/claude-140-cfg || exit 1
tree=$PWD/$1
logs=$PWD/logs-tests-$1
mkdir -p $logs
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 selection walks #140: tests at the head"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/977
lock=~/buster-fast-bench/exclusive.sh
CTS=$HOME/buster-fast-bench/claude-435/c-testsuite
unset CPATH C_INCLUDE_PATH
test1() { # name command...
    local n=$1
    shift
    "$lock" bash -c "cd $tree && $* > $logs/$n.log 2>&1; echo \"exit \$?\" >> $logs/$n.log"
    echo "$n $(tail -1 $logs/$n.log): $(tail -2 $logs/$n.log | head -1 | cut -c1-160)"
}
test1 select ./build/compiler test-tier1-select
test1 liveness ./build/compiler test-tier1-liveness
test1 emit ./build/compiler test-tier1-emit
test1 pipeline ./build/compiler test-tier1-pipeline --cross-check
test1 cfg ./build/compiler test-tier1-cfg
test1 frame-execution ./build/compiler test-tier1-frame-execution
test1 allocation ./build/compiler test-tier1-allocation
test1 schedule ./build/compiler test-tier1-schedule
test1 model ./build/compiler test-tier1-model
test1 c-testsuite ./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt $CTS
echo done > $logs/done
