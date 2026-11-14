#!/bin/bash
cd ~/buster-fast-bench/2536-step1-claude
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (step 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
timeout 600 ~/buster-fast-bench/exclusive.sh ./profile.sh "$PWD/compiler-head2" profile-w2048 --emit-window=2048 > profile-w2048.log 2>&1
timeout 600 ~/buster-fast-bench/exclusive.sh ./profile.sh "$PWD/compiler-head2" profile-w0 --emit-window=0 > profile-w0.log 2>&1
