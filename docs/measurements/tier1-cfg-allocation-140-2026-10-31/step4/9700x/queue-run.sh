#!/usr/bin/env bash
# queue-run.sh HEAD: benchmark-tier1-pipeline, the fixtures' run time by Tier 1, Tier 0 and clang -O0/-O2, five processes
# of HEAD's build (already built), each one hold of the shared lock, pinned to CPU 2. Logs in logs-run-HEAD/.
set -u
cd ~/buster-fast-bench/claude-140-cfg
head=$1
logs=logs-run-$head
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 edge moves #140: run time"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
for round in 1 2 3 4 5; do
    "$lock" bash -c "cd $head && unset CPATH C_INCLUDE_PATH && taskset -c 2 ./build/compiler benchmark-tier1-pipeline > ../$logs/run-$round.log 2>&1; echo \"exit \$?\" >> ../$logs/run-$round.log"
done
echo done > "$logs/done"
