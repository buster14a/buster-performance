#!/bin/bash
cd ~/buster-fast-bench/2531-step3c-claude
EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 600 ./run7.sh faultprof s4b none memo
echo "status $?"
