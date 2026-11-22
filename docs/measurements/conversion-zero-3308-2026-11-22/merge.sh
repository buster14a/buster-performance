#!/bin/bash
set -e
cd ~/buster-fast-bench/3308-claude
clang -O2 merge.c -o merge
export EXCLUSIVE_OWNER=claude-3308 EXCLUSIVE_TITLE="buster #3308: Tier 0 zeroes int-to-float destinations" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3308
~/buster-fast-bench/exclusive.sh bash -c 'cat /proc/loadavg; timeout 60 taskset -c 2 ./merge; cat /proc/loadavg' 2>&1 | tee merge.log
