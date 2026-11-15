#!/bin/bash
# rerun.sh: after run.sh, the checker's fixtures again by objects2.sh (one hold), whose comparison covers the units
# that make no object.
set -u
cd ~/buster-fast-bench/2536-step2c3-claude
export EXCLUSIVE_OWNER=claude-2536-step2c3 EXCLUSIVE_TITLE="Problem 2536 (step 2.2c.3 part 1 deferred lowering)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
until grep -q '^done' out/holds.log 2>/dev/null; do sleep 30; done
~/buster-fast-bench/exclusive.sh timeout 900 ./objects2.sh checker "$PWD/head" >> out/holds.log 2>&1
echo "./objects2.sh checker status $?" >> out/holds.log
echo done2 >> out/holds.log
