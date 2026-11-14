#!/bin/bash
cd ~/buster-fast-bench/2536-step1-claude
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (default windows)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
for k in 1 2; do timeout 600 ~/buster-fast-bench/exclusive.sh ./ab.sh "$PWD/compiler-head4" "$PWD/ab-head4-$k" > ab-head4-$k.log 2>&1; done
